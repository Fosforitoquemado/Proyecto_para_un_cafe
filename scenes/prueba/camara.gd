extends Node3D

@export var intensidad := 0.5
@export var suavidad := 5.0

@onready var camera_3d: Camera3D = $Camera3D

var rotacion_objetivo := Vector2.ZERO

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("rueda_mouse_abajo"):
		camera_3d.fov += 2
	if event.is_action_pressed("rueda_mouse_arriba"):
		camera_3d.fov -= 2

func _process(delta):
	var mouse_pos = get_viewport().get_mouse_position()
	var viewport_size = get_viewport().size
	
	var centro = viewport_size / 2.0
	var offset = (mouse_pos - centro) / centro
	
	rotacion_objetivo.x = -offset.y * intensidad
	rotacion_objetivo.y = -offset.x * intensidad
	
	rotation.x = lerp(rotation.x, rotacion_objetivo.x, delta * suavidad)
	rotation.y = lerp(rotation.y, rotacion_objetivo.y, delta * suavidad)
