extends Node

class_name StateMachine

@export var initial_state : State
@export var fsm_name : String = "(No name assigned)"
@export var owner_ref : Node2D
var states : Dictionary = {}
var current_state : State

var is_transitioning := false
var force_mode := false


func _ready() -> void:
	await get_tree().process_frame
	current_state = null
	if(get_parent() is Node2D):
		owner_ref = get_parent()


	if(fsm_name == "(No name assigned)"):
		fsm_name = self.name
	print(fsm_name, " State Machine says: ")

	for child in get_children():
		if(child is State):
			print("Added state: ", child.state_name)
			states[child.state_name] = child
			if(owner_ref):
				child.owner_ref = owner_ref
			child.transition_to.connect(_on_transition_to)
			child.transition_to_with_params.connect(_on_transition_to_params)
			
	
	if(states.is_empty()): print("No states found.")
	elif(initial_state):
		transition(initial_state.state_name)
	else:
		print(fsm_name, " State Machine says: ", "no initial state assigned")


func _process(delta: float) -> void:
	if(current_state):
		current_state.process(delta)

func _physics_process(delta: float) -> void:
	if(current_state):
		current_state.phyProcess(delta)

func transition(state_name : String, params : Dictionary = {}):
	#if(is_transitioning):
		#print(fsm_name, " State Machine says: Busy")
		#return
#
	#is_transitioning = true

	if(states.has(state_name)):
		var temp_state : State = states[state_name]

		if(current_state):
			current_state.exit()

		if(temp_state): 
			temp_state.enter(params)

		current_state = temp_state
	else:
		print(fsm_name, " State Machine says: ", state_name, " state not found")

	#is_transitioning = false


func _on_transition_to(state_name: String, emitter_state: State) -> void:
	if(force_mode):
		print(fsm_name, "State Machine says:: Force mode, can't transition. Caller: ",emitter_state.state_name, "Wants to transition to: ", state_name)
		return
	var new_state : State
	if(states.has(state_name)): 
		new_state = states[state_name]
	else:
		print(fsm_name, "State Machine says:: Invalid state: ", state_name)
		return
	if(!new_state.can_enter):
		print(fsm_name, "State Machine says:: ", state_name, " is blocked. Cannot enter")
		return
	if(emitter_state != current_state):
		print(fsm_name, "State Machine says: ", emitter_state.state_name, " is the emitter, but ", current_state.state_name, " is the caller. Cannot transition")
		return

	print(fsm_name, "State Machine says: Transitioning from: ", current_state, "to: ", state_name)

	transition(state_name)


func _on_transition_to_params(state_name: String, emitter_state: State, params : Dictionary) -> void:
	if(force_mode):
		print(fsm_name, "State Machine says:: Force mode, can't transition. Caller: ",emitter_state.state_name, "Wants to transition to: ", state_name)
		return
	var new_state : State
	if(states.has(state_name)): 
		new_state = states[state_name]
	else:
		print(fsm_name, "State Machine says:: Invalid state: ", state_name)
		return
	if(!new_state.can_enter):
		print(fsm_name, "State Machine says:: ", state_name, " is blocked. Cannot enter")
		return
	if(emitter_state != current_state):
		print(fsm_name, "State Machine says: ", emitter_state.state_name, " is the emitter, but ", current_state.state_name, " is the caller. Cannot transition")
		return

	print(fsm_name, "State Machine says: Transitioning from: ", current_state, "to: ", state_name)

	transition(state_name, params)


func force_transition(state_name: String, params : Dictionary = {}) -> void:
	if(!states.has(state_name)):
		print(fsm_name, "State Machine says:: Invalid state: ", state_name)
		return

	var new_state : State = states[state_name]

	if(!new_state.can_enter):
		print(fsm_name, "State Machine says:: ", state_name, " is blocked. Cannot enter")
		return

	#force_mode = true
	#is_transitioning = true

	print(fsm_name, "State Machine says: Forcing Transition from: ", current_state, "to: ", state_name)

	current_state.force_transition(state_name, params)

	#if(current_state):
		#current_state.exit()
#
	#current_state = new_state
	#current_state.enter()

	#is_transitioning = false

func request_transition(state_name: String, params : Dictionary = {}) -> void:
	if(!states.has(state_name)):
		print(fsm_name, "State Machine says:: Invalid state: ", state_name)
		return

	var new_state : State = states[state_name]

	if(!new_state.can_enter):
		print(fsm_name, "State Machine says:: ", state_name, " is blocked. Cannot enter")
		return


	print(fsm_name, "State Machine says: Requesting Transition from: ", current_state, "to: ", state_name)

	current_state.request_transition(state_name, params)

	#if(current_state):
		#current_state.exit()
#
	#current_state = new_state
	#current_state.enter()

	#is_transitioning = false


func block_state(state_name : String) -> void:
	var state : State
	if(states.has(state_name)): 
		state = states[state_name]
	else:
		print(fsm_name, "State Machine says:: Invalid state: ", state_name)
		return

	state.can_enter = false
	print(fsm_name, "State Machine says: ", state_name, " Blocked ")

func unblock_state(state_name : String) -> void:
	var state : State
	if(states.has(state_name)): 
		state = states[state_name]
	else:
		print(fsm_name, "State Machine says:: Invalid state: ", state_name)
		return

	state.can_enter = true
	print(fsm_name, "State Machine says: ", state_name, " Unblocked ")


func get_state(state_name: String) -> State:
	return states[state_name] if states.has(state_name) else null
