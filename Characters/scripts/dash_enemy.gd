extends Enemy

@export var dash_speed : float = 1000
@export var max_dash_dist : float = 500

func _ready() -> void:
	super._ready()
	vulnerable = true

func blocked():
	if fsm.current_state.state_name == "attack":
		anim_player.seek(0,true)
		anim_player.play("attack_charge")
