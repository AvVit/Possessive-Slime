extends PlayerStates

func enter():
	super.enter()
	player.current_speed = player.run_speed


func process(delta : float):
	if(!Input.is_action_pressed("run")):
		transition_to.emit("idle", self)
	if(Input.is_action_just_pressed("jump")):
		transition_to.emit("jump", self)
	if(Input.is_action_pressed("left")):
		player.dir = -1
	elif(Input.is_action_pressed("right")):
		player.dir = 1
	else:
		transition_to.emit("idle", self)
	
	player.velocity.x = player.current_speed * player.dir
