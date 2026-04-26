extends StaticBody2D

class_name Breakable

@export var life := 100

func _process(delta: float) -> void:
	if life <= 0: queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area is Weapon and area.enem.is_in_group("possessed"):
		life -= area.damage
		$AnimationPlayer.play("ouch")
