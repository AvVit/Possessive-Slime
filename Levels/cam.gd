extends Camera2D

var player_ref
var target = Vector2.ZERO
@export var cam_speed = 500
@export var cam_dir_speed = 2000
@export var player_offset_x = 50
@export var player_offset_y = 200


func _ready() -> void:
	player_ref = get_tree().get_first_node_in_group("player")
	if player_ref.possessed_enemy:
		player_ref = player_ref.possessed_enemy

func _physics_process(delta: float) -> void:
	player_ref = get_tree().get_first_node_in_group("player")
	if player_ref.possessed_enemy:
		player_ref = player_ref.possessed_enemy

	target = player_ref.global_position
	target.x += player_ref.non_zero_dir.x * player_offset_x 
	target.y -= player_offset_y

	global_position = global_position.move_toward(
		player_ref.global_position,
		cam_speed * delta
	)
	global_position.x = move_toward(
		global_position.x,
		target.x,
		cam_dir_speed * delta
	)
	global_position.y = move_toward(
		global_position.y,
		target.y,
		cam_dir_speed * delta
	)
