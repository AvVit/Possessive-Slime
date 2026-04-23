extends CharacterBody2D
class_name Mouse

@export var gravValue = 1
@export var walk_speed = 300
@export var run_speed = 700
@export var air_decel = 10
@export var max_air_apeed = 200
@export var jump_force = 1100

var gravity = 1
var current_speed = 0
var dir = 0
var cur_poss : Possessable

@onready var possess_area = $PossessRange
@onready var possess_rad = get_node("PossessRange/CollisionShape2D").shape.radius

signal possessing(body : Node2D) #used to communicate with states

#func _ready() -> void:
	##for obj in get_tree().get_nodes_in_group("Possessable"):
		##if obj is Possessable:
			##print("Found: ", obj.name)

func _process(delta: float) -> void:
	if(!is_on_floor()): velocity.y += gravity
	move_and_slide()


func _on_possess_range_body_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is Possessable:
		body.show_possess_sign()

func _on_possess_range_body_shape_exited(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body is Possessable:
		print(body.name)
		body.hide_possess_sign()

func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var space = get_world_2d().direct_space_state
		var mouse_pos = get_global_mouse_position()

		var circle = CircleShape2D.new()
		circle.radius = 10   # click tolerance

		var query = PhysicsShapeQueryParameters2D.new()
		query.shape = circle
		query.transform = Transform2D(0, mouse_pos)
		query.collision_mask = 2
		query.collide_with_bodies = true

		var results = space.intersect_shape(query)

		for hit in results:
			var obj = hit.collider
			if obj is Possessable:
				print("Clicked on Possessable: ", obj.name)
				if obj.vulnerable:
					for body in possess_area.get_overlapping_bodies():
						if(body == obj):
							if(cur_poss != null):
								if(cur_poss == obj): break
								cur_poss.is_possessed = false
							print(obj.name, " is in range")
							if not body.is_connected("wait_for_possession", possess):
								body.waiting_possession.connect(possess)
								print("Connected 'waiting_possession' of ", body.name, " to possess()")
							body.wait_for_possession()

#func _input(event):
	## Mouse in viewport coordinates.
	#if event is InputEventMouseButton and event.is_pressed():
		#match event.button_index:
			#MOUSE_BUTTON_LEFT:
				#var mousepos = get_global_mouse_position()
				#var mouse_dist = (mousepos - global_position).length()
				#print("Player pos: ", global_position, " Mouse Pos: ", mousepos, " distance: ", mouse_dist)
#
				#print(get_tree().current_scene)
				#print(self.get_parent())
#
				#if(mouse_dist <= possess_rad):
					#for body in possess_area.get_overlapping_bodies():
						#if(body is Possessable):
							#print("Clicked on Possessable: ", body.name)
							#if not body.is_connected("wait_for_possession", possess):
								#body.waiting_possession.connect(possess)
								#print("Connected 'waiting_possession' of ", body.name, " to possess()")
							#body.wait_for_possession()

func possess(body : Possessable): #Called when possessable is waiting for possession. Anything that
								  #mouse needs to do before possessing needs to be done here before 
								  #calling body.get_possessed
	print("Possessessing: ", body.name)
	possessing.emit(body)
