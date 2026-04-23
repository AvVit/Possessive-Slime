extends EnemyState

var player_ref : Slime
var diff

func enter(params: Dictionary = {}):
	super.enter()
	enem_ref.dir.x = 0
	enem_ref.current_speed = enem_ref.run_speed
	enem_ref.anim_player.play("run")
	player_ref = get_tree().get_first_node_in_group("player")
	if player_ref:
		diff = player_ref.global_position.x - enem_ref.global_position.x
		if diff != 0:
			enem_ref.dir.x = sign(diff) * 1

func process(delta : float):
	if(enem_ref.player_in_attack_range):
		transition_to.emit("attack", self)
		return
	if(!player_ref or !enem_ref.player_visible):
		transition_to.emit("idle", self)
		print(enem_ref.name, ": Player ref not found.")
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

	diff = player_ref.global_position.x - enem_ref.global_position.x
	var target_dir_x = sign(diff) * 1
	enem_ref.dir.x = move_toward(enem_ref.dir.x, target_dir_x, delta * enem_ref.dir_change_speed)
	#if diff != 0:
		#enem_ref.dir.x = sign(diff) * 1
	enem_ref.velocity.x = enem_ref.current_speed * enem_ref.dir.x
