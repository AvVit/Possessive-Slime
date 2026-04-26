extends PossessedState


func _ready():
	add_to_group("p_states")

func enter(msg := {}):
	super.enter()
	enem_ref.audio.stream = enem_ref.run_sound
	enem_ref.audio.play()
	enem_ref.anim_player.play("run")

func process(delta: float) -> void:
	if Input.is_action_just_pressed("attack"):
		transition_to.emit("p_attack", self)
	if Input.is_action_just_pressed("jump"):
		transition_to.emit("p_jump", self)
		return
	if enem_ref.velocity.y > 0:
		transition_to.emit("p_fall", self)
		return
	var input_dir = Input.get_axis("left", "right")

	if input_dir == 0:
		transition_to.emit("p_idle", self)
		return

	enem_ref.dir.x = input_dir
	enem_ref.velocity.x = input_dir * enem_ref.run_speed

	# stop running if key released
	if !Input.is_action_pressed("run"):
		transition_to.emit("p_walk", self)
		return
