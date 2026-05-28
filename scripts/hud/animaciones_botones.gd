extends Button

@onready var texture: TextureRect = $".."

var num
var num2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_focus_entered() -> void:
	num = randi_range(3,9)
	texture.position.y += 4
	pass # Replace with function body.


func _on_focus_exited() -> void:
	texture.position.y -= 4
	pass # Replace with function body.


func _on_mouse_entered() -> void:
	texture.modulate = Color(0.735, 0.735, 0.735, 1.0)
	num2 = randi_range(3,10)
	texture.size.x += 9
	texture.position.x -= 4.5
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	texture.modulate = Color(1.0, 1.0, 1.0, 1.0)
	texture.size.x -= 9
	texture.position.x += 4.5
	pass # Replace with function body.
