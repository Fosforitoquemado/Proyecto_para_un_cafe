extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = str("DIA: ", SaveLoad.contents_to_save.values()[0] + 1)
	print("DIAAAAAAAAAAA", text)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_reset_file_pressed() -> void:
	await get_tree().physics_frame
	text = str("DIA: ", SaveLoad.contents_to_save.values()[0] + 1)
	pass # Replace with function body.
