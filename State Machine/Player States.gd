extends State
class_name PlayerStates

var player : Slime

func enter(params: Dictionary = {}):
	player = owner_ref as Slime
	assert(player != null)
	if(not player.possessing.is_connected(on_possessing)):
		player.possessing.connect(on_possessing)

func on_possessing(body: Possessable):
	if(!(state_name == get_parent().current_state.name)):
		return
	print("Possessing: ", body.name)
	player.cur_poss = body
	transition_to.emit("possessing", self)
