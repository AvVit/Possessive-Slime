extends CharacterBody2D

signal collected

func _physics_process(delta: float) -> void:
	if !is_on_floor():
		velocity.y += 500*delta
	else:
		velocity = Vector2.ZERO
	move_and_slide()

func _ready() -> void:
	velocity.y = randf_range(-100, -200)
	velocity.x = randf_range(-20, 20)
	print("SPAWNED")

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") or body.is_in_group("possessed"):
		get_tree().get_first_node_in_group("level_base").collected()
		queue_free()
