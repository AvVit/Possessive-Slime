extends PlayerStates

func enter(params: Dictionary = {}):
	super.enter()
	player.set_collision_layer_value(1, false)
	player.set_collision_mask_value(3, false)
	player.current_speed = 0

func process(delta : float):
	player.velocity.x = 0
