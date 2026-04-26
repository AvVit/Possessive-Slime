extends EnemyState

#var player_ref : Slime


func enter(params: Dictionary = {}):
	super.enter()
	enem_ref.audio.stream = enem_ref.parry_sound
	enem_ref.audio.play()
	enem_ref.current_speed = 0
	enem_ref.anim_player.play("parried")
	enem_ref.anim_player.animation_finished.connect(_on_stun_finished)
	if(params.has("parry_damage")):
		enem_ref.posture += params["parry_damage"]
	else:
		print(self.name, ": No parry damage")
	#player_ref = get_tree().get_first_node_in_group("player")

func exit():
	super.exit()
	enem_ref.posture = enem_ref.max_posture - 10
	#enem_ref.posture = 0
	enem_ref.anim_player.animation_finished.disconnect(_on_stun_finished)

func process(delta : float):
	enem_ref.velocity.x = 0

func _on_stun_finished(parry : String):
	print("finished: ", parry)
	if(get_parent().current_state == self and parry == "parried"):
		if(enem_ref.is_possessed):
			transition_to.emit("p_idle", self)
			return
		
		if(enem_ref.player_visible and enem_ref.player_in_attack_range):
			transition_to.emit("attack", self)
			return
		elif(enem_ref.possess_visible):
			transition_to.emit("pos_chase", self)
			return
		elif(enem_ref.player_visible):
			transition_to.emit("chase", self)
			#print(enem_ref.name, ": Player out of attack range.")
			return
		else:
			transition_to.emit("idle", self)
