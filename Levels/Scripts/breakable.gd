extends StaticBody2D

class_name Breakable

@export var min_stars := 1
@export var life := 20
@export var level_ref : Level
@onready var audio = $AudioStreamPlayer2D

func _ready() -> void:
	audio.stream = preload("res://Audio/wallhit.wav")
	$StarsLabel.text = ": " + str(min_stars)
	if !level_ref :
		level_ref = get_tree().get_first_node_in_group("level_base")

func _process(delta: float) -> void:
	if life <= 0: queue_free()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if level_ref.stars < min_stars:
		return
	audio.play()
	if area is Weapon and area.enem.is_in_group("possessed"):
		life -= area.damage
		$AnimationPlayer.play("ouch")
