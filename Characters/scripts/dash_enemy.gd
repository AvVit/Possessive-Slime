extends Enemy

@export var dash_speed : float = 1000
@export var max_dash_dist : float = 500
@onready var attack_col = $"Dash Range/CollisionShape2D3"

var player_in_dash_range := false
var possess_in_dash_range := false

func _ready() -> void:
	attack_multi = 2
	attack_col.shape.size.y = max_dash_dist
	attack_col.position.x = max_dash_dist/2
	super._ready()
	vulnerable = true

func blocked():
	if fsm.current_state.state_name == "attack":
		anim_player.seek(0,true)
		anim_player.play("attack_charge")


func _on_dash_range_body_entered(body: Node2D) -> void:
	if(body.is_in_group("possessed")):
		player_in_dash_range = false
		possess_in_dash_range = true
	elif(body.is_in_group("player")):
		possess_in_dash_range = false
		player_in_dash_range = true


func _on_dash_range_body_exited(body: Node2D) -> void:
	if(body.is_in_group("possessed")):
		possess_in_dash_range = false
	elif(body.is_in_group("player")):
		player_in_dash_range = false
