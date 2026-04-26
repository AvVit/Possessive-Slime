extends Enemy

@export var dash_speed : float = 1000
@export var max_dash_dist : float = 500
@onready var attack_col = $"Attack Range/CollisionShape2D3"

func _ready() -> void:
	attack_col.shape.size.y = max_dash_dist
	attack_col.position.x = max_dash_dist/2
	super._ready()
	vulnerable = true

func blocked():
	if fsm.current_state.state_name == "attack":
		anim_player.seek(0,true)
		anim_player.play("attack_charge")
