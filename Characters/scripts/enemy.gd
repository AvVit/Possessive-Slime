extends Possessable

class_name Enemy

@onready var anim_player : AnimationPlayer= $AnimationPlayer
@onready var floor_detect : Area2D = $"Floor Detection"
@onready var wall_detect : Area2D = $"Wall Detection"
@onready var fsm : StateMachine = $EnemyFSM
@onready var posses_sign = $"UI/Possess Sign"
@onready var health_bar = $UI/health
@onready var UI = $UI
@onready var posture_bar : ProgressBar = $UI/posture
@onready var audio : AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var blonk = preload("res://Audio/block.wav")
@onready var bonk = preload("res://Audio/Bonk Sound Effect.wav")
@onready var parry_sound = preload("res://Audio/parry.wav")
@onready var swing_sound = preload("res://Audio/whoosh1.wav")
@onready var walk_sound = preload("res://Audio/Sound Effects - Footsteps.wav")
@onready var run_sound = preload("res://Audio/run.wav")

@export var num_stars := 1
@export var dir_change_speed := 1
@export var posture := 0
@export var max_posture := 100
@export var posture_recovery_speed := 0.5
@export var star : PackedScene

var non_zero_dir := Vector2.RIGHT
var is_dead = false
var scale_x_right = self.scale.x
var scale_x_left = -self.scale.x
var roam_timer : Timer
var player_visible := false
var player_in_attack_range := false
var possess_visible := false
var possess_in_attack_range := false
var player_ref : Slime
var attack_multi : float = 1

signal yes_vulnerable(body : Node2D)
signal no_vulnerable(body : Node2D)

var time = 0

func _ready() -> void:
	posture_bar.max_value = max_posture
	health_bar.max_value = health
	hide_possess_sign()
	vulnerable = false
	roam_timer = Timer.new()
	roam_timer.one_shot = true
	add_child(roam_timer)
	print("Self:", self)
	print("Children:", get_children())

	for player in get_tree().get_nodes_in_group("player"):
		print(self.name, ": Player found: ", player.name)
		if player.has_signal("parry"):
			print(self.name, ": parry signal found: ", player.name)
			player.parry.connect(_on_parry)
			player_ref = player

func _process(delta: float) -> void:
	posture = clampf(posture, 0, max_posture)
	
	time += delta
	if(time > 1):
		if(fsm.current_state.state_name != "parried"):
			posture -= posture_recovery_speed
		print("posture: ", posture, "\nrecovery: ", posture_recovery_speed * delta)
		time = 0
	if(posture >= max_posture):
		posture = max_posture
		vulnerable = true
		if(fsm.current_state.state_name != "parried"):
			fsm.force_transition("parried")
	else:
		vulnerable = false

	
	posture_bar.value = posture
	if non_zero_dir.x != dir.x and dir.x != 0:
		non_zero_dir = dir
	health_bar.value = health
	if health <= 0 and fsm.current_state.state_name != "dead":
		fsm.force_transition("dead")

	if player_ref:
		if player_ref.is_dead and player_visible:
			player_visible = false
		if vulnerable and !player_ref.vulnerable_poss.get(self):
			yes_vulnerable.emit(self)
		elif !vulnerable and player_ref.vulnerable_poss.get(self):
			no_vulnerable.emit(self)
	super._process(delta)
	if self.dir.x != 0 and fsm.current_state.state_name != "p_attack":
		transform.x = sign(dir.x) * abs(transform.x)
		UI.scale.x = transform.x.x

func _on_vision_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("possessed") and body != self:
		if body.is_dead: return
		print(name, ": Possessed enemy seen")
		#fsm.request_transition("pos_chase")
		possess_visible = true

	elif body.is_in_group("player"):
		if body.is_dead: return
		print(name, ": Player seen")
		player_visible = true


func _on_alert_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		print(name, ": Player escaped")
		player_visible = false
	elif body.is_in_group("possessed") and body != self:
		print(name, ": Possessed enemy escaped")
		possess_visible = false


func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("possessed") and body != self:
		if body.is_dead: return
		print(name, ": Possessed enemy in attack range")
		possess_in_attack_range = true
		player_in_attack_range = false
		
	elif body.is_in_group("player"):
		if body.is_dead: return
		print(name, ": Player in attack range")
		player_in_attack_range = true
		possess_in_attack_range = false
		


func _on_attack_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("player") :
		print(name, ": Player out of attack range")
		player_in_attack_range = false
	elif (body.is_in_group("possessed") and body != self):
		print(name, ": Possessed enemy out of attack range")
		possess_in_attack_range = false


func _on_parry(enem : Enemy, parry_damage : float):
	var params = {"parry_damage" : parry_damage}
	print(self.name, ": parried")
	if(enem == self):
		fsm.force_transition("parried", params)


func show_possess_sign() -> void:
	if vulnerable:
		posses_sign.show()

func hide_possess_sign() -> void:
	posses_sign.hide()


func _on_hurt_area_area_entered(area: Area2D) -> void:
	if health == 0:
		return
	if area is Weapon:
		posture += area.posture_damage
		print("Enemy :: OUCH : ", area.damage)
		#take_damage(area.damage)
		var params : Dictionary
		params["damage"] = area.damage
		if is_possessed:
			fsm.request_transition("p_hurt", params)
		else:
			fsm.request_transition("hurt", params)
	else:
		print("OUCH : ", area)

func take_damage(damage : float):
	health -= damage
	if health <=0:
		health = 0

func blocked():
	audio.stream = blonk
	audio.play()
	anim_player.seek(0, true)
