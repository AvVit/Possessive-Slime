extends EnemyState



func enter(params: Dictionary = {}):
	super.enter()
	enem_ref.anim_player.play("idle")

func process(delta: float) -> void:
	if enem_ref.is_on_floor():
		transition_to.emit("idle", self)
	enem_ref.velocity.x = 0
