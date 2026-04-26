extends EnemyState


func enter(params: Dictionary = {}):
	super.enter()

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
	if(!enem_ref.player_visible):
		enem_ref.dir.x = -enem_ref.dir.x
	enem_ref.anim_player.animation_finished.disconnect(_on_hurt_timeout)

func process(delta : float):
	enem_ref.velocity.x = 0

func _on_hurt_timeout(anim : String):
	if(anim == "hurt"):
		transition_to.emit("idle", self)
		return
