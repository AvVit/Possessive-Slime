extends PlayerStates


func process(delta : float):
	if(player.is_on_floor()):
		transition_to.emit("idle", self)
		return

	if((Input.is_action_pressed("left") and player.dir.x == 1) or (Input.is_action_pressed("right") and player.dir.x == -1) ):
		if(player.current_speed <= 0):
			player.current_speed = 0
			player.dir.x = -player.dir.x
		else:
			player.current_speed -= player.air_decel

	elif((Input.is_action_pressed("left") and player.dir.x == -1) or (Input.is_action_pressed("right") and player.dir.x == 1)):
		if(player.current_speed <= player.max_air_speed):
			player.current_speed += player.air_decel
	
	player.velocity.x = player.current_speed * player.dir.x
