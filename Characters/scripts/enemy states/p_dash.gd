extends PossessedState

var dash_dist = 400
var dash_timer : Timer
var dash = true

func _ready() -> void:
	dash_timer = Timer.new()
	dash_timer.one_shot = true
	add_child(dash_timer)

func enter(params: Dictionary = {}) -> void:
	super.enter()
	dash = true
	dash_timer.wait_time = dash_dist/enem_ref.dash_speed
	dash_timer.start()
	print("dash time: ", dash_timer.wait_time)
	dash_timer.timeout.connect(on_dash_timeout)


func exit():
	super.exit()
	dash_timer.timeout.disconnect(on_dash_timeout)
	enem_ref.velocity.x = 0

func process(delta : float):
	if dash:
		enem_ref.velocity.x = enem_ref.dir.x * enem_ref.dash_speed
	else:
		enem_ref.velocity.x = 0

func on_dash_timeout():
	dash = false
	transition_to.emit("p_idle", self)
	return
