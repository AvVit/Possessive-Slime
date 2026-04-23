extends PlayerStates

var goto_pos = Vector2.ZERO
var cur_pos : Possessable

func enter():
	super.enter()
	print("Possessing state entered")
	player.gravity = 0
	player.set_collision_layer(0)
	player.set_collision_mask(0)
	if(player.cur_poss):
		if(player.cur_poss.possess_point):
			goto_pos = player.cur_poss.possess_point.global_position
		else:
			goto_pos = player.cur_poss.global_position
	if(goto_pos != null):
		if(goto_pos != player.global_position):
			player.velocity = (goto_pos - player.global_position).normalized() * player.jump_force
			print(player.velocity)

func process(delta : float):
	if(goto_pos != null):
		if(player.global_position.distance_to(goto_pos) < 5):
			player.velocity = Vector2.ZERO
			transition_to.emit("possessed", self)
		#print(player.velocity)
	else:
		print("No goto pos")
		transition_to.emit("idle", self)
