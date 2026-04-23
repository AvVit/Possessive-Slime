extends PlayerStates

var y_dir = 0
var vec_dir = Vector2.ZERO

func enter():
	super.enter()
	player.gravity = 0
	player.current_speed = player.walk_speed

func exit():
	super.exit()
	player.gravity = player.gravValue

func process(delta : float):

	if(Input.is_action_pressed("left")):
		player.dir = -1
	elif(Input.is_action_pressed("right")):
		player.dir = 1
	else:
		player.dir = 0

	if(Input.is_action_pressed("swim_up")):
		y_dir = -1
	elif(Input.is_action_pressed("swim_down")):
		y_dir = 1
	else:
		y_dir = 0
	
	vec_dir = Vector2(player.dir, y_dir).normalized()

	player.velocity = player.current_speed * vec_dir
