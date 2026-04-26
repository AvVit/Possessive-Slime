extends PossessedState

var max_air_speed : float
var input_dir : float

func enter(params: Dictionary = {}):
	super.enter()
	max_air_speed = maxf(enem_ref.max_air_speed, abs(enem_ref.velocity.x))
	input_dir = Input.get_axis("left", "right")
	enem_ref.anim_player.play("fall")

func process(delta : float):
	if Input.is_action_just_pressed("run"):
		enem_ref.velocity.y = 0
		transition_to.emit("p_dash", self)
		return
	if Input.is_action_just_pressed("attack"):
		transition_to.emit("p_attack", self)
	if(enem_ref.is_on_floor()):
		transition_to.emit("p_idle", self)
		return
	input_dir = Input.get_axis("left", "right")

	if(sign(input_dir) != enem_ref.dir.x):
		max_air_speed = enem_ref.max_air_speed

func phyProcess(delta : float):
	if enem_ref.velocity.x != 0:
		enem_ref.dir.x = sign(enem_ref.velocity.x)

	enem_ref.velocity.x = move_toward(
		enem_ref.velocity.x,
		max_air_speed * input_dir,
		enem_ref.air_decel * delta
	)
