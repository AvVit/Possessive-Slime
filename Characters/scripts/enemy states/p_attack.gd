extends PossessedState
#var player_ref : Slime

func enter(params: Dictionary = {}):
	super.enter()
	enem_ref.current_speed = 0
	enem_ref.anim_player.play("p_attack")
	enem_ref.anim_player.animation_finished.connect(_on_attack_finished)
	#player_ref = get_tree().get_first_node_in_group("player")

func exit():
	super.exit()
	enem_ref.anim_player.animation_finished.disconnect(_on_attack_finished)

func process(delta : float):
	var input_dir = Input.get_axis("left", "right")
	enem_ref.dir.x = input_dir
	if(Input.is_action_pressed("run")):
		enem_ref.velocity.x = input_dir * enem_ref.run_speed
	else:
		enem_ref.velocity.x = input_dir * enem_ref.walk_speed



func _on_attack_finished(attack : String):
	print("finished: ", attack)
	transition_to.emit("p_idle", self)
