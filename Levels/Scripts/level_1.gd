extends Level


func _on_next_level_body_entered(body: Node2D) -> void:
	if body.is_in_group("possessed"):
		get_tree().change_scene_to_file("res://Levels/level_2.tscn")

func collected():
	stars += 1
	$UI/StarsLabel.text = str(stars)


func _on_death_body_entered(body: Node2D) -> void:
	get_tree().reload_current_scene()
