extends Button


func _on_pressed() -> void:
	SaveLoad.contents_to_save["dinero"] = 0.0
	SaveLoad.contents_to_save["day"] = 0
	SaveLoad.contents_to_save["tutorial_yes_no"] = false
	SaveLoad.contents_to_save["tutorial_inspeccion"] = false
	SaveLoad.contents_to_save["tutorial_pc"] = false
	SaveLoad.contents_to_save["tutorial_baul"] = false
	SaveLoad._save()
	pass # Replace with function body.
