extends Area2D
class_name Weapon
@export var enem : Enemy
@export var base_damage : float = 10

@onready var damage : float = base_damage
@onready var multi = enem.attack_multi

func _process(delta: float) -> void:
	if(multi != enem.attack_multi):
		multi = enem.attack_multi
		damage = base_damage * multi
