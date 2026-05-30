extends Node
@export var camera: Camera3D
@export var nodo_camara:Node3D

func vista_normal():
	camera.rotation = Vector3(0,deg_to_rad(70),0)
	camera.position = nodo_camara.global_position
	camera.current = true
	camera.fov = 75

func ver_patente_adelante(pos):
	camera.rotation = Vector3(0,deg_to_rad(0),0)
	camera.position = pos
	camera.fov = 75

func ver_patente_atras(pos):
	camera.rotation = Vector3(0,deg_to_rad(180),0)
	camera.position = pos
	camera.fov = 75
func ver_vtv(pos):
	camera.rotation = Vector3(0,deg_to_rad(0),0)
	camera.position = pos
	camera.fov = 75
func ver_escritorio(pos):
	camera.rotation = Vector3(deg_to_rad(-90),deg_to_rad(90),0)
	camera.position = pos
	camera.fov = 40
func ver_baul(pos,rot):
	camera.rotation = rot#Vector3(0,deg_to_rad(180),0)
	camera.position = pos
	camera.fov = 75
func update_fov(value):
	camera.fov = value
