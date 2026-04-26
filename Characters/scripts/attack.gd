extends EnemyState

#var player_ref : Slime
var hurt_timer : Timer


func _ready() -> void:
	hurt_timer = Timer.new()
	hurt_timer.wait_time = 0.5
	hurt_timer.one_shot = true
	add_child(hurt_timer)

func enter(params: Dictionary = {}):
	super.enter()
	hurt_timer.timeout.connect(on_hurt_timeout)
	enem_ref.attack_multi = 2
	enem_ref.current_speed = 0
	enem_ref.anim_player.play("attack")
	enem_ref.anim_player.animation_finished.connect(_on_attack_finished)
	#player_ref = get_tree().get_first_node_in_group("player")

func exit():
	super.exit()
	hurt_timer.timeout.disconnect(on_hurt_timeout)
	hurt_timer.stop()
	enem_ref.anim_player.animation_finished.disconnect(_on_attack_finished)

func process(delta : float):
	if(!enem_ref.player_visible and !enem_ref.possess_visible):
		transition_to.emit("idle", self)
		#print(enem_ref.name, ": Player out of visible range.")
		return
	if(enem_ref.velocity.y < 0):
		transition_to.emit("fall", self)
		return


	enem_ref.velocity.x = 0

func _on_attack_finished(attack : String):
	print("finished: ", attack)
	if(get_parent().current_state == self and (attack == "attack" or attack == "attack_hurt")):
		if(!enem_ref.player_in_attack_range and enem_ref.player_visible):
			transition_to.emit("chase", self)
			#print(enem_ref.name, ": Player out of attack range.")
			return
		elif(!enem_ref.possess_in_attack_range and enem_ref.possess_visible):
			transition_to.emit("pos_chase", self)
			#print(enem_ref.name, ": Player out of attack range.")
			return
		elif enem_ref.possess_visible or enem_ref.player_visible:
			enem_ref.anim_player.play("attack")

func request_transition(state_name : String, params : Dictionary = {}):
	if(state_name == "hurt"):
		if params.has("damage"):
			enem_ref.take_damage(params["damage"])
			var pos = enem_ref.anim_player.current_animation_position
			enem_ref.anim_player.play("attack_hurt")
			enem_ref.anim_player.seek(pos, true)
			hurt_timer.start()
	else:
		super.request_transition(state_name, params)

func on_hurt_timeout():
	var pos = enem_ref.anim_player.current_animation_position
	enem_ref.anim_player.play("attack")
	enem_ref.anim_player.seek(pos, true)
