extends Node2D

func _ready() -> void:
	$AudioStreamPlayer2D.stream = preload("res://Audio/winsound.wav")
	$AudioStreamPlayer2D.play()

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Levels/level_1.tscn")
