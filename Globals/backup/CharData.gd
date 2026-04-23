# res://Globals/CharData.gd
extends Resource
class_name CharData

@export var char_type : Global.CHAR
@export var name: String
@export var id: int

@export var scene: PackedScene

@export var health: int = 100
@export var home_level: String
@export var current_level: String

@export var spawned := false
