extends CharacterBody2D

# PARRY AREA IS IN LAYER 3
# POSSESSION AREA IS IN LAYER 2

class_name Slime

var dir := Vector2.RIGHT
var current_speed := 0
var is_dead := false
var possess_in_range : Dictionary[Node2D, bool] = {}
var vulnerable_poss : Dictionary[Node2D, bool] = {}
var health := 100.0
var poss_point : Node2D

@export var grav_value := 1
@export var walk_speed := 400
@export var air_decel := 10
@export var max_air_speed := 200
@export var jump_force := 1100.0


@onready var Shell := $Polygons/Shell
@onready var NormalBody = $Polygons/Body
@onready var HurtBody = $Polygons/HurtBody
@onready var normal_face = $Polygons/Face
@onready var dead_face = $Polygons/DeadFace
@onready var FSM = $SlimeFSM
@onready var gravity := grav_value
@onready var health_bar = $health
@onready var HurtArea = $HurtArea
@onready var ParryArea = $ParryArea
@onready var parryLabel = $"block or parry"
@onready var possessArea = $PossessionRange

signal parry(enem : Enemy)
signal possessing

func _ready() -> void:
	for body in get_tree().get_nodes_in_group("possessable"):
		if body.has_signal("yes_vulnerable"):
			print("YES_VULNERABLE CONNNECTED")
			body.yes_vulnerable.connect(on_poss_vulnerable)
		if body.has_signal("no_vulnerable"):
			print("NO_VULNERABLE CONNNECTED")
			body.no_vulnerable.connect(on_poss_not_vulnerable)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("possess"):
		if !possess_in_range.is_empty():
			possess(possess_in_range.keys()[0])
	for body in vulnerable_poss:
		if possessArea.get_overlapping_bodies().has(body) and !possess_in_range.get(body):
			body.show_possess_sign()
			possess_in_range[body] = true
	for body in possess_in_range:
		if !possessArea.get_overlapping_bodies().has(body) or !body.vulnerable:
			body.hide_possess_sign()
			possess_in_range.erase(body)

	health_bar.value = health
	if(!is_on_floor()): velocity.y += gravity
	move_and_slide()
	if(health <= 0 && FSM.current_state.state_name != "dead"):
		die()

func harden():
	Shell.show()

func soften():
	Shell.hide()
	#ShellCol.disabled = true

func die():
	normal_face.hide()
	dead_face.show()
	is_dead = true
	FSM.force_transition("dead")

func _on_area_body_entered(body):
	var space = get_world_2d().direct_space_state
	
	var from = global_position
	var to = body.global_position

	var query = PhysicsRayQueryParameters2D.create(from, to)
	query.exclude = [self]

	var result = space.intersect_ray(query)

	var contact_point

	if result:
		contact_point = result.position
	else:
		contact_point = project_to_area_edge(to)

	var poly = Polygon2D.new()
	poly.polygon = [
		Vector2(-10, -10),
		Vector2(10, -10),
		Vector2(10, 10),
		Vector2(-10, 10)
	]

	poly.global_position = contact_point
	get_tree().current_scene.add_child(poly)



func project_to_area_edge(target_global_pos):
	var shape_node = $CollisionShape2D
	var shape = shape_node.shape

	var center = global_position
	var dir = (target_global_pos - center).normalized()

	if shape is CircleShape2D:
		return center + dir * shape.radius

	elif shape is RectangleShape2D:
		var extents = shape.extents

		# scale direction to hit rectangle boundary
		var t_x = extents.x / abs(dir.x) if dir.x != 0 else INF
		var t_y = extents.y / abs(dir.y) if dir.y != 0 else INF

		var t = min(t_x, t_y)
		return center + dir * t

	else:
		# fallback if unknown shape
		return center + dir * 10.0


func take_damage(damage):
	health -= damage
	if(health <= 0): 
		health = 0
		return


func _on_hurt_area_area_entered(area: Area2D) -> void:
	if health == 0:
		return
	if area is Weapon:
		print("OUCH : ", area.damage)
		#take_damage(area.damage)
		var params : Dictionary
		params["damage"] = area.damage
		FSM.request_transition("hurt", params)
	else:
		print("OUCH : ", area)


func _on_possession_range_body_exited(body: Node2D) -> void:
	if body is Possessable:
		body.hide_possess_sign()
		if possess_in_range.get(body):
			possess_in_range[body] = false


func on_poss_vulnerable(body : Node2D):
	if body is Possessable and possessArea.get_overlapping_bodies().has(body):
		body.show_possess_sign()
		possess_in_range[body] = true
		vulnerable_poss[body] = true

func on_poss_not_vulnerable(body : Node2D):
	if possess_in_range.get(body):
		body.hide_possess_sign()
		possess_in_range.erase(body)
	if vulnerable_poss.get(body):
		vulnerable_poss.erase(body)



########################################

var possessed_enemy : Enemy = null

func possess(target: Possessable) -> void:
	if target == null:
		return
	if !(target is Enemy):
		return
	if !target.vulnerable:
		return

	var enemy := target as Enemy

	# store reference
	possessed_enemy = enemy

	# teleport slime to possession point
	if enemy.possess_point:
		poss_point = enemy.possess_point
	else:
		global_position = enemy.global_position
		poss_point = enemy
	
	enemy.is_possessed = true
	# disable slime control (optional but recommended)
	set_physics_process(false)
	set_process(false)
	#visible = false
	
	# activate possessed states
	_activate_possessed_states(enemy)

	# force FSM into a possessed state (example: idle)
	if enemy.fsm:
		enemy.fsm.force_transition("p_idle")
	FSM.force_transition("possessed")



func unpossess(enemy: Enemy) -> void:
	if enemy == null:
		return

	# restore slime
	visible = true
	set_physics_process(true)
	set_process(true)

	# place slime near enemy
	global_position = enemy.global_position + Vector2(40, 0)
	enemy.is_possessed = false
	# deactivate possessed states
	_deactivate_possessed_states(enemy)

	# return enemy to normal state
	if enemy.fsm:
		enemy.fsm.force_transition("idle")
	
	FSM.force_transition("idle")

	possessed_enemy = null


func _activate_possessed_states(enemy: Enemy) -> void:
	for child in enemy.fsm.get_children():
		if child is Node and child.is_in_group("p_states"):
			child.set_process(true)
			child.set_physics_process(true)



func _deactivate_possessed_states(enemy: Enemy) -> void:
	for child in enemy.fsm.get_children():
		if child is Node and child.is_in_group("p_states"):
			child.set_process(false)
			child.set_physics_process(false)
