extends Button


func _on_pressed() -> void:
	SaveLoad.contents_to_save["dinero"] = 0.0
	SaveLoad.contents_to_save["day"] = 0
	SaveLoad._save()
	pass # Replace with function body.
