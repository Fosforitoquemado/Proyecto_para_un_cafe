extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	pass # Replace with function body.

func _on_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
