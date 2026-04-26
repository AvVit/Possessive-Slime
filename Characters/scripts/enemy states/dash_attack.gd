extends EnemyState

#var player_ref : Slime
var hurt_timer : Timer
var player_ref = null
var dash := false
var dash_time : float
var dash_timer : Timer

func _ready() -> void:
	dash_timer = Timer.new()
	dash_timer.one_shot = true
	add_child(dash_timer)

	hurt_timer = Timer.new()
	hurt_timer.wait_time = 0.5
	hurt_timer.one_shot = true
	add_child(hurt_timer)

func enter(params: Dictionary = {}):
	super.enter()
	dash_time = enem_ref.max_dash_dist/enem_ref.dash_speed
	
	if enem_ref.possess_visible:
		player_ref = get_tree().get_first_node_in_group("possessed")
		if player_ref:
			print("Possessed found" )
	elif enem_ref.player_visible:
		player_ref = get_tree().get_first_node_in_group("player")
		if player_ref:
			print("Player found" )
	else:
		print("No player_ref")

	hurt_timer.timeout.connect(on_hurt_timeout)
	dash_timer.timeout.connect(on_dash_timeout)
	enem_ref.attack_multi = 1
	enem_ref.current_speed = 0
	enem_ref.anim_player.play("attack_charge")
	enem_ref.anim_player.animation_finished.connect(_on_attack_finished)
	#player_ref = get_tree().get_first_node_in_group("player")

func exit():
	super.exit()
	dash_timer.timeout.connect(on_dash_timeout)
	hurt_timer.timeout.disconnect(on_hurt_timeout)
	hurt_timer.stop()
	enem_ref.anim_player.animation_finished.disconnect(_on_attack_finished)

func process(delta : float):
	if(!enem_ref.player_visible and !enem_ref.possess_visible):
		transition_to.emit("idle", self)
		#print(enem_ref.name, ": Player out of visible range.")
		return
	if(enem_ref.velocity.y < 0):
		transition_to.emit("fall", self)
		return
	if(dash):
		enem_ref.velocity.x = enem_ref.dash_speed * enem_ref.dir.x
	else:
		enem_ref.velocity.x = 0



func _on_attack_finished(attack : String):
	print("finished: ", attack)
	
	if(get_parent().current_state == self and attack == "attack_charge"):
		var dist = 0
		dash = true
		if player_ref:
			dist = player_ref.global_position.x - enem_ref.global_position.x
			enem_ref.dir.x = sign(dist)
			dash_time = minf(enem_ref.max_dash_dist, abs(dist)) / enem_ref.dash_speed
		dash_timer.wait_time = dash_time
		dash_timer.start()
		print("dash dist: ",  minf(enem_ref.max_dash_dist, abs(dist)), " / speed: ", enem_ref.dash_speed, " = dash_time: ", dash_time)

	if(get_parent().current_state == self and (attack == "attack_discharge" or attack == "attack_hurt")):
		if(!enem_ref.player_in_attack_range and enem_ref.player_visible):
			transition_to.emit("chase", self)
			#print(enem_ref.name, ": Player out of attack range.")
			return
		elif(!enem_ref.possess_in_attack_range and enem_ref.possess_visible):
			transition_to.emit("pos_chase", self)
			#print(enem_ref.name, ": Player out of attack range.")
			return
		elif enem_ref.possess_visible or enem_ref.player_visible:
			enem_ref.anim_player.play("attack_charge")

func request_transition(state_name : String, params : Dictionary = {}):
	if(state_name == "hurt"):
		if params.has("damage"):
			enem_ref.take_damage(params["damage"])
			var pos = enem_ref.anim_player.current_animation_position
			enem_ref.anim_player.play("attack_hurt")
			enem_ref.anim_player.seek(pos, true)
			hurt_timer.start()
	else:
		super.request_transition(state_name, params)

func on_hurt_timeout():
	var pos = enem_ref.anim_player.current_animation_position
	enem_ref.anim_player.play("attack_charge")
	enem_ref.anim_player.seek(pos, true)

func on_dash_timeout():
	dash = false
	enem_ref.anim_player.play("attack_discharge")
