extends Button

@onready var texture: TextureRect = $".."

var active_click = false
var mouse = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if event.is_action_released("click_izq"):
		if active_click == true:
			await  get_tree().process_frame
			release_focus()
			active_click = false

func _on_focus_entered() -> void:
	if active_click == false:
		active_click = true
		texture.position.y += 4
	pass # Replace with function body.


func _on_focus_exited() -> void:
	if active_click == true:
		active_click = false
		texture.position.y -= 4
	pass # Replace with function body.


func _on_mouse_entered() -> void:
	if mouse == false:
		mouse = true
		texture.modulate = Color(0.735, 0.735, 0.735, 1.0)
		texture.size.x += 9
		texture.position.x -= 4.5
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	if mouse == true:
		mouse = false
		texture.modulate = Color(1.0, 1.0, 1.0, 1.0)
		texture.size.x -= 9
		texture.position.x += 4.5
	pass # Replace with function body.
