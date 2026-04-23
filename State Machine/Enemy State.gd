extends State

class_name EnemyState

var enem_ref : Enemy

func enter(params: Dictionary = {}) -> void:
	enem_ref = owner_ref as Enemy
	assert(enem_ref != null)
