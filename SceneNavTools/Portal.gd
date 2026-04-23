extends Area2D

class_name Portal

signal triggered(portal: Portal, body: Node2D)

@export_file("*.tscn") var dst_scene: String

@export var dst_point : String

func _enter_tree() -> void:
	add_to_group("portal")
