extends PlayerStates

@onready var timer = Timer.new()

func _ready() -> void:
	add_child(timer)

func enter(params: Dictionary = {}):
	super.enter()
	player.current_speed = 0
	player.HurtBody.show()
	player.take_damage(10)
	if not timer.timeout.is_connected(_on_hurt_timeout):
		timer.timeout.connect(_on_hurt_timeout)
	timer.wait_time = 0.5
	timer.start()

func exit():
	super.exit()
	timer.stop()
	player.HurtBody.hide()

func process(delta : float):
	player.velocity.x = 0

func _on_hurt_timeout():
	transition_to.emit("idle", self)
	return
