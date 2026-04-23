extends PlayerStates

func enter(params: Dictionary = {}):
	super.enter()
	player.current_speed = 0

func process(delta : float):
	if(Input.is_action_pressed("block")):
		transition_to.emit("block", self)
		return
	if(Input.is_action_pressed("left") || Input.is_action_pressed("right")):
		transition_to.emit("walk", self)
		return
	if(Input.is_action_just_pressed("jump")):
		transition_to.emit("jump", self)
		return
	if(!player.is_on_floor()):
		transition_to.emit("fall", self)
		return
	player.velocity.x = 0
