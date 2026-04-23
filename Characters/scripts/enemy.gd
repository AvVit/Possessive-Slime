extends Possessable

class_name Enemy

@onready var anim_player : AnimationPlayer= $AnimationPlayer
@onready var floor_detect : Area2D = $"Floor Detection"
@onready var wall_detect : Area2D = $"Wall Detection"
@onready var fsm : StateMachine = $EnemyFSM
@onready var posses_sign = $"Possess Sign"

@export var dir_change_speed := 1


var scale_x_right = self.scale.x
var scale_x_left = -self.scale.x
var roam_timer : Timer
var player_visible := false
var player_in_attack_range := false
var player_ref : Slime

signal yes_vulnerable(body : Node2D)
signal no_vulnerable(body : Node2D)

func _ready() -> void:
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
	if player_ref:
		if vulnerable and !player_ref.vulnerable_poss.get(self):
			yes_vulnerable.emit(self)
		elif !vulnerable and player_ref.vulnerable_poss.get(self):
			no_vulnerable.emit(self)
	super._process(delta)
	if self.dir.x != 0:
		transform.x = sign(dir.x) * abs(transform.x)


func _on_vision_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print(name, ": Player seen")
		player_visible = true


func _on_alert_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		print(name, ": Player escaped")
		player_visible = false


func _on_attack_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print(name, ": Player in attack range")
		player_in_attack_range = true


func _on_attack_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		print(name, ": Player out of attack range")
		player_in_attack_range = false


func _on_parry(enem : Enemy):
	print(self.name, ": parried")
	if(enem == self):
		fsm.force_transition("parried")


func show_possess_sign() -> void:
	if vulnerable:
		posses_sign.show()

func hide_possess_sign() -> void:
	posses_sign.hide()
