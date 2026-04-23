extends Node

# -------------------------
# CHARACTER SCENES
# -------------------------
var mouse_scene := preload("res://Characters/mouse.tscn")
var cat_scene := preload("res://Characters/Cat.tscn")
var fish_scene := preload("res://Characters/Fish.tscn")

# -------------------------
# DATA REGISTRY
# -------------------------
var entities: Dictionary[String, CharData] = {}
var next_char_index := 0
var mouse_ref : CharData

enum CHAR { MOUSE, CAT, FISH }

# -------------------------
# INITIALIZE
# -------------------------
func _enter_tree():
	mouse_ref = register_character(CHAR.MOUSE, "mouse")

func _ready():
	connect_signals()

func connect_signals():
	for portal : Portal in get_tree().get_nodes_in_group("portal"):
		portal.triggered.connect(_on_portal_triggered)



# -------------------------
# CREATE CHARACTER (DATA ONLY)
# -------------------------
func register_character(char_enum: CHAR, char_name: String) -> CharData:

	if entities.has(char_name):
		print(char_name, " already exists")
		return entities[char_name]

	var data := CharData.new()
	data.name = char_name
	data.id = next_char_index

	match char_enum:
		CHAR.MOUSE:
			data.scene = mouse_scene
		CHAR.CAT:
			data.scene = cat_scene
		CHAR.FISH:
			data.scene = fish_scene
		_:
			print("Invalid char_type: ", char_enum, "\nFailed to instantiate ", char_name)
			return null

	next_char_index += 1

	entities[char_name] = data
	return data


# -------------------------
# SPAWN CHARACTER IN CURRENT SCENE
# -------------------------
func spawn_character(ref):

	var char_name: String

	if ref is CharData:
		char_name = ref.name
	elif ref is String and entities.has(ref):
		char_name = ref
	else:
		print("Invalid character reference")
		return

	var data: CharData = entities[char_name]

	# -------------------------
	# DUPLICATE PREVENTION FIX
	# -------------------------
	if get_tree().current_scene and get_tree().current_scene.has_node(char_name):
		return

	var inst = data.scene.instantiate()

	inst.name = char_name

	get_tree().current_scene.add_child(inst)

	inst.global_position = get_spawn_position(char_name)

	data.spawned = true
	data.current_level = get_tree().current_scene.name


# -------------------------
# TELEPORT CHARACTER
# -------------------------
func teleport(ref, portal: Portal):
	var dst_point := portal.dst_point
	var dst_scene := portal.dst_scene
	var char_name: String

	if ref is CharData:
		char_name = ref.name
	elif ref is String and entities.has(ref):
		char_name = ref
	else:
		print("Invalid teleport reference")
		return

	var data: CharData = entities[char_name]

	# change scene
	print("Changing scene")
	get_tree().change_scene_to_file(dst_scene)
	print("Waiting for scene_changed signal")
	await get_tree().scene_changed
	print("Scene Changed: ", get_tree().current_scene)
	connect_signals()

	data.spawned = false

	# respawn in new scene
	spawn_character(char_name)

	# move to portal spawn point
	var inst = get_tree().current_scene.get_node_or_null(char_name)
	if inst:
		inst.global_position = get_spawn_position(dst_point)


# -------------------------
# SPAWN HELPERS
# -------------------------
func get_spawn_position(name: String) -> Vector2:
	var pos = null
	var default_pos = Vector2.ZERO

	var spawns = get_tree().get_first_node_in_group("spawn_points")
	if spawns:
		for p in spawns.get_children():
			if p.name == name:
				pos = p.global_position
			if p.name == "default":
				default_pos = p.global_position

	return pos if pos else default_pos


func _on_portal_triggered(portal: Portal, body: Node2D):
	if body is Mouse:
		print("Teleporting ", body.name)
		teleport("mouse", portal)
