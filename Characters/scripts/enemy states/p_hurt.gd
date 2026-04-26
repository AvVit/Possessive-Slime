extends PossessedState


func enter(params: Dictionary = {}):
	super.enter()
	enem_ref.audio.stream = enem_ref.bonk
	enem_ref.audio.play()
	var damage = 0
	if params.is_empty():
		print(self.name, ": EMPTY PARAMS")
	elif params.has("damage"):
		damage = params["damage"]
		print("damage: ", damage)
	enem_ref.anim_player.play("hurt")
	enem_ref.anim_player.animation_finished.connect(_on_hurt_timeout)
	enem_ref.take_damage(damage)

func exit():
	super.exit()
	enem_ref.anim_player.animation_finished.disconnect(_on_hurt_timeout)

func process(delta : float):
	enem_ref.velocity.x = 0

func _on_hurt_timeout(anim : String):
	if(anim == "hurt"):
		if(enem_ref.is_possessed):
			transition_to.emit("p_idle", self)
			return
