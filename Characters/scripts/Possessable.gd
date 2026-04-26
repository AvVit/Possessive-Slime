extends CharacterBody2D
class_name Possessable

#Possessable should be in layer 2

@export var possess_point : Marker2D
@export var gravValue = 3000
@export var walk_speed = 300
@export var run_speed = 500
@export var air_decel = 10000
@export var max_air_speed = 300
@export var jump_force = 1200
@export var health = 100
@export var dir = Vector2.RIGHT
@export var vulnerable = false

@onready var gravity = gravValue

var is_possessed = false
var current_speed = 0
signal waiting_possession(body : Possessable)

func _enter_tree() -> void:
	add_to_group("possessable")

#func _ready() -> void:
	#add_to_group("Possessable")

func _process(delta: float) -> void:
	if(is_possessed):
		hide_possess_sign()


func _physics_process(delta: float) -> void:
	if(!is_on_floor()):
		velocity.y += gravity * delta
	move_and_slide()

func show_possess_sign() -> void:
	pass

func hide_possess_sign() -> void:
	pass

func wait_for_possession() -> void: #to be called when the player clicks on a valid possessable
									#thats in range. Waits until get_possessed is called. This is
									#to ensure that player's possession animation is complete
									#and to freeze the possessable till its possessed
	waiting_possession.emit(self)   

func get_possessed() -> void: #to be called when player is ready to possess object, this actually
							  #posesses the possessable
	print(self.name, " Possessed")
	hide_possess_sign()
