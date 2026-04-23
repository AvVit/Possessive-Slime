extends PossessedState

func _ready():
	add_to_group("p_states")

func enter(msg := {}):
	super.enter()
	enem_ref.anim_player.play("idle")
	enem_ref.current_speed = 0

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
	if input_dir != 0:
		transition_to.emit("p_walk", self)
		return
	enem_ref.velocity.x = 0
