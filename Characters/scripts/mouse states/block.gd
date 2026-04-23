extends PlayerStates

var block_or_parry = "block"

func enter(params: Dictionary = {}):
	super.enter()
	block_or_parry = "block"
	var hurt_area : Area2D = player.HurtArea
	var parry_area : Area2D = player.ParryArea
	var weapon_areas : Array[Weapon]
	for area in parry_area.get_overlapping_areas():
		if area is Weapon:
			block_or_parry = "parry"
			weapon_areas.append(area)
			for area2 in hurt_area.get_overlapping_areas():
				if area2 is Weapon:
					block_or_parry = "hurt"
	if(block_or_parry == "parry"):
		for weapon in weapon_areas:
			player.parry.emit(weapon.owner)
	player.parryLabel.text = block_or_parry
	player.current_speed = 0
	player.harden()

func exit():
	super.exit()
	player.soften()

func process(delta : float):
	if(!Input.is_action_pressed("block")):
		transition_to.emit("idle", self)
		return
	player.velocity.x = 0

func request_transition(state_name : String, params : Dictionary = {}):
	if(state_name != "hurt"):
		transition_to.emit(state_name, self)
