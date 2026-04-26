extends Node

class_name State

var owner_ref : Node2D
@export var state_name : String
@export var can_enter : bool = true

signal transition_to(state_name : String, emitter_state : State)
signal transition_to_with_params(state_name : String, emitter_state : State, params : Dictionary)

func enter(params: Dictionary = {}):
	pass

func exit():
	pass

func process(delta : float):
	pass

func phyProcess(delta : float):
	pass

func request_transition(state_name : String, params : Dictionary = {}):
	if(params.is_empty()):
		transition_to.emit(state_name, self)
	else:
		transition_to_with_params.emit(state_name, self, params)

func force_transition(state_name : String, params : Dictionary = {}): # Don't override
	if params:
		transition_to_with_params.emit(state_name, self, params)
	else:
		transition_to.emit(state_name, self)
