extends EnemyState


func enter(params: Dictionary = {}):
	super.enter()
	enem_ref.anim_player.play("dead")
	enem_ref.current_speed = 0

func process(delta : float):
	enem_ref.velocity.x = 0
