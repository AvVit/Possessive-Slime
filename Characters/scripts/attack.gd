extends EnemyState

#var player_ref : Slime

func enter(params: Dictionary = {}):
	super.enter()
	enem_ref.current_speed = 0
	enem_ref.anim_player.play("attack")
	enem_ref.anim_player.animation_finished.connect(_on_attack_finished)
	#player_ref = get_tree().get_first_node_in_group("player")

func exit():
	super.exit()
	enem_ref.anim_player.animation_finished.disconnect(_on_attack_finished)

func process(delta : float):


	if(!enem_ref.player_visible):
		transition_to.emit("idle", self)
		#print(enem_ref.name, ": Player out of visible range.")
		return
	if(enem_ref.velocity.y < 0):
		transition_to.emit("fall", self)
		return


	enem_ref.velocity.x = 0

func _on_attack_finished(attack : String):
	print("finished: ", attack)
	if(get_parent().current_state == self and attack == "attack"):
		if(!enem_ref.player_in_attack_range):
			transition_to.emit("chase", self)
			#print(enem_ref.name, ": Player out of attack range.")
			return
		else:
			enem_ref.anim_player.play("attack")
