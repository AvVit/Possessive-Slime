extends PlayerStates

var max_air_speed : float
var input_dir : float

func enter(params: Dictionary = {}):
	super.enter()
	max_air_speed = maxf(player.max_air_speed, abs(player.velocity.x))
	input_dir = Input.get_axis("left", "right")
	if player.is_on_floor():
		player.velocity.y = -player.jump_force

func process(delta: float):
	if player.is_on_floor():
		transition_to.emit("idle", self)
		return

	input_dir = Input.get_axis("left", "right")
	if(sign(input_dir) != player.dir.x):
		max_air_speed = player.max_air_speed

func phyProcess(delta: float):
	player.velocity.x = move_toward(
		player.velocity.x,
		max_air_speed * input_dir,
		player.air_decel * delta
	)
