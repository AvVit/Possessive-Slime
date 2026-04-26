extends PossessedState

var enter_vel : float

func _ready():
	add_to_group("p_states")

func enter(msg := {}):
	super.enter()
	enter_vel = enem_ref.velocity.x
	enem_ref.anim_player.play("jump")
	if(enem_ref.is_on_floor()):
		enem_ref.velocity.y = -(enem_ref.jump_force)


func process(delta : float):
	if Input.is_action_just_pressed("attack"):
		transition_to.emit("p_attack", self)
	if(enem_ref.is_on_floor() and enem_ref.velocity.y == 0):
		transition_to.emit("p_idle", self)
		return
	if(enem_ref.velocity.y > 0):
		transition_to.emit("p_fall", self)
		return
	
	var input_dir = Input.get_axis("left", "right")
	if(enem_ref.non_zero_dir.x != input_dir and input_dir != 0):
		if(enem_ref.current_speed <= 0):
			enem_ref.current_speed = 0
			enem_ref.non_zero_dir.x = -enem_ref.non_zero_dir.x
		else:
			enem_ref.current_speed -= enem_ref.air_decel

	elif(enem_ref.non_zero_dir.x == input_dir and input_dir != 0):
		if(enem_ref.current_speed <= enem_ref.max_air_speed):
			enem_ref.current_speed += enem_ref.air_decel

	if(enter_vel != 0):
		enem_ref.velocity.x += enem_ref.current_speed * enem_ref.non_zero_dir.x
		enem_ref.velocity.x = clampf(enem_ref.velocity.x,-enem_ref.max_air_speed, enem_ref.max_air_speed)
	else:
		enem_ref.velocity.x = enem_ref.current_speed * enem_ref.non_zero_dir.x
