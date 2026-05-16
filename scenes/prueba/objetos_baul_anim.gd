extends Area3D

@onready var anim = $"../AnimationPlayer"

var animando = false
var abierto = false

func _input_event(camera, event, position, normal, shape_idx):
	if animando:
		return
	if event is InputEventMouseButton:
		if event.pressed:
			if abierto == false:
				animando = true
				anim.play("abrir")
				await anim.animation_finished
				animando = false
				abierto = true
				print("abierto")
			else:
				animando = true
				anim.play("cerrar")
				await anim.animation_finished
				animando = false
				abierto = false
				print("cerrado")
