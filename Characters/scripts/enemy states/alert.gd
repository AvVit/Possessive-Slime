extends EnemyState


func enter(params: Dictionary = {}):
	
	super.enter()
	enem_ref.current_speed = 0
	enem_ref.anim_player.play("alert")
	enem_ref.anim_player.animation_finished.connect(on_anim_complete)

func process(delta : float):
	if(enem_ref.velocity.y > 0):
		transition_to.emit("fall", self)
		return
	enem_ref.velocity.x = 0

func exit():
	super.exit()
	enem_ref.anim_player.animation_finished.disconnect(on_anim_complete)


func on_anim_complete(anim : String):
	if(enem_ref.possess_visible):
		transition_to.emit("pos_chase", self)
		return
	elif(enem_ref.player_visible):
		transition_to.emit("chase", self)
		return
	else:
		transition_to.emit("idle", self)
