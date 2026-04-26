extends EnemyState

@onready var timer = Timer.new()

func _ready() -> void:
	add_child(timer)

func enter(params: Dictionary = {}):
	
	super.enter()
	enem_ref.current_speed = enem_ref.walk_speed
	enem_ref.anim_player.play("walk")

	if not timer.timeout.is_connected(_on_roam_timeout):
		timer.timeout.connect(_on_roam_timeout)
	timer.wait_time = randi_range(1, 6)
	print("roam timer wait time: ",timer.wait_time)
	timer.start()

func exit():
	super.exit()
	disable_stuff()

func process(delta : float):
	if(enem_ref.player_visible):
		transition_to.emit("alert", self)
		return
	if(enem_ref.possess_visible):
		transition_to.emit("alert", self)
		return
	if(enem_ref.velocity.y < 0):
		transition_to.emit("fall", self)
		return
	var no_floor = true
	if(enem_ref.velocity.y > 0):
		transition_to.emit("fall", self)
		return
	for body in enem_ref.floor_detect.get_overlapping_bodies():
		if body.is_in_group("floor_or_wall"):
			no_floor = false
			break
	if no_floor:
		print("Enemy: No floor detected")
		transition_to.emit("idle", self)
		return

	for body in enem_ref.wall_detect.get_overlapping_bodies():
		if body is Enemy and body != enem_ref:
			transition_to.emit("idle", self)
			return
		if body.is_in_group("floor_or_wall"):
			print("Enemy: wall detected")
			transition_to.emit("idle", self)
			return

	enem_ref.velocity.x = enem_ref.current_speed * enem_ref.dir.x


func _on_roam_timeout():
	if(get_parent().current_state == self):
		print("current state is walk")
		print("walk: roam timer out")
		transition_to.emit("idle", self)
		return


func disable_stuff():
	timer.stop()
