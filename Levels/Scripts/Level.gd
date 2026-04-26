extends Node2D
class_name Level

@export var level_name : String
@export var default_spawn : Marker2D
@export var game_over_node : Node2D
@export var player_ref : Slime
@onready var audio = $AudioStreamPlayer2D
var stars = 0

func _ready() -> void:
	game_over_node.hide()
	if !player_ref:
		player_ref = get_tree().get_first_node_in_group("player")
	if player_ref:
		player_ref.player_dead.connect(game_over)

func game_over():
	game_over_node.show()

func collected():
	stars += 1
