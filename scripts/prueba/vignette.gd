extends AnimatedSprite2D

var active = false

func _ready():
	var pantalla = get_viewport_rect().size
	var tex = sprite_frames.get_frame_texture("new_animation", 0)

	scale = pantalla / tex.get_size()
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if active == true:
		modulate.a -= 0.01

func _on_animation_finished() -> void:
	active = true
	pass # Replace with function body.
