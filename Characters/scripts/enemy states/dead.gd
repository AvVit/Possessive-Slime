extends EnemyState



func enter(params: Dictionary = {}):
	super.enter()
	for i in enem_ref.num_stars:
		var star = enem_ref.star.instantiate()
		star.global_position = enem_ref.global_position - Vector2(0, 50)
		get_tree().current_scene.add_child(star)
	enem_ref.is_dead = true
	if enem_ref.is_possessed:
		enem_ref.player_ref.unpossess(enem_ref)
	enem_ref.anim_player.play("dead")
	enem_ref.current_speed = 0
	enem_ref.health_bar.hide()
	enem_ref.posture_bar.hide()
	enem_ref.set_collision_mask_value(2, true)
	enem_ref.set_collision_mask_value(1, false)
	enem_ref.set_collision_layer_value(3, false)
	

func process(delta : float):
	enem_ref.velocity.x = 0
