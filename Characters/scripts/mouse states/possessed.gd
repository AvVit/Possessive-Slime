extends PlayerStates

func enter(params: Dictionary = {}):
	super.enter()
	player.set_collision_layer_value(1, false)
	player.set_collision_mask_value(1, false)
	player.possessed_enemy.set_collision_mask_value(1, false)
	player.health_bar.hide()

func exit():
	super.exit()
	player.set_collision_layer_value(1, true)
	player.set_collision_mask_value(1, true)
	player.possessed_enemy.set_collision_mask_value(1, true)
	player.health_bar.show()

func process(delta : float):
	player.velocity.x = 0
	player.global_position = player.poss_point.global_position
	if Input.is_action_just_pressed("unpossess"):
		player.unpossess(player.possessed_enemy)


func request_transition(state_name : String, params : Dictionary = {}):
	if(state_name != "hurt"):
		transition_to.emit(state_name, self)
