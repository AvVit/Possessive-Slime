extends PlayerStates


func enter(params: Dictionary = {}):
	super.enter()
	if(player.is_on_floor()):
		player.velocity.y = -(player.jump_force)

func process(delta : float):
	if(player.is_on_floor() and player.velocity.y == 0):
		transition_to.emit("idle", self)
		return
	if(player.velocity.y > 0):
		transition_to.emit("fall", self)
		return
	
	var input_dir = Input.get_axis("left", "right")

	if(player.dir.x != input_dir):
		if(player.current_speed <= 0):
			player.current_speed = 0
			player.dir.x = -player.dir.x
		else:
			player.current_speed -= player.air_decel

	elif(input_dir == player.dir.x):
		if(player.current_speed <= player.max_air_speed):
			player.current_speed += player.air_decel
	
	player.velocity.x += player.current_speed * player.dir.x
	player.velocity.x = clampf(player.velocity.x,-player.max_air_speed, player.max_air_speed)
