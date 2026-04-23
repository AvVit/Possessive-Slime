extends PlayerStates

func enter(params: Dictionary = {}):
	super.enter()
	player.current_speed = 0

func process(delta : float):
	player.velocity.x = 0
