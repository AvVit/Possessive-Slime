extends EnemyState


func enter(params: Dictionary = {}):
	super.enter()
	enem_ref.current_speed = 0
	enem_ref.anim_player.stop()

func process(delta : float):
	enem_ref.velocity.x = 0
