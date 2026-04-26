extends PlayerStates

func enter(params: Dictionary = {}):
	super.enter()
	player.current_speed = player.walk_speed


func process(delta : float):
	if(Input.is_action_pressed("block")):
		transition_to.emit("block", self)

	if(Input.is_action_just_pressed("jump")):
		transition_to.emit("jump", self)
		return
	if(Input.is_action_pressed("left")):
		player.dir.x = -1
	elif(Input.is_action_pressed("right")):
		player.dir.x = 1

	else:
		transition_to.emit("idle", self)
		return
	player.velocity.x = player.current_speed * player.dir.x
