extends Control


func _on_next_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/hud/tuto_2.tscn")
	pass # Replace with function body.

func _on_help_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/hud/tuto_1.tscn")
	pass # Replace with function body.
