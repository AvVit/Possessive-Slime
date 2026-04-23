extends EnemyState

var no_floor := true

@onready var timer = Timer.new()

func _ready() -> void:
	add_child(timer)

func enter(params: Dictionary = {}):
	
	super.enter()
	no_floor = true

	
	enem_ref.current_speed = 0
	enem_ref.anim_player.play("idle")
	if not timer.timeout.is_connected(_on_roam_timeout):
		timer.timeout.connect(_on_roam_timeout)
	timer.wait_time = randi_range(1, 3)
	print("roam timer wait time: ",timer.wait_time)
	timer.start()

func exit():
	super.exit()
	disable_stuff()

func process(delta : float):
	if(enem_ref.player_visible):
		transition_to.emit("chase", self)
		return
	if(enem_ref.velocity.y > 0):
		transition_to.emit("fall", self)
	enem_ref.velocity.x = 0

func _on_roam_timeout():
	if(randf() < 0.3):
		enem_ref.dir.x = -enem_ref.dir.x

	print("IDIFJIDFHSDFHFIH")
	if(get_parent().current_state == self):
		print("Current state is idle")

		print("ROAM TIMER OUT")
		print(self.name, ": roam timer out")

		for body in enem_ref.floor_detect.get_overlapping_bodies():
			if body.is_in_group("floor_or_wall"):
				print(self.name, ": floor detected")
				no_floor = false
				break
			else:
				print(body, "Is not floor")

		if no_floor:
			print(self.name, ": no floor detected")
			enem_ref.dir.x = -enem_ref.dir.x

		else:
			for body in enem_ref.wall_detect.get_overlapping_bodies():
				if body is Enemy and body != enem_ref:
					if (randi_range(0,1)  == 0):
						enem_ref.dir.x = -enem_ref.dir.x
						print("HI")
					break
				if body.is_in_group("floor_or_wall"):
					print(self.name, ": wall detected")
					enem_ref.dir.x = -enem_ref.dir.x
					break

		print(enem_ref.dir.x)
		transition_to.emit("walk", self)
		return


func _on_player_visible():
	pass


func disable_stuff():
	timer.stop()
