extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = str("DINERO: ", SaveLoad.contents_to_save.values()[1])
	print("DIAAAAAAAAAAA", text)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_reset_file_pressed() -> void:
	await get_tree().physics_frame
	text = str("DINERO: ", SaveLoad.contents_to_save.values()[1])
	pass # Replace with function body.
