extends Area3D

@onready var daymanager: Node = get_node("/root/Main/DayManager")

var ocupado = false

var hay_condicion = false

var uicontroller

func _ready() -> void:
	uicontroller = get_tree().get_first_node_in_group("ui_manager")
	var dia = daymanager.get_day()
	if "objetos_baul" in dia.documentos_habilitados:
		hay_condicion = true
	pass # Replace with function body.

func _input_event(camera, event, position, normal, shape_idx):
	if ocupado:
		return
	if event is InputEventMouseButton:
		if event.pressed and hay_condicion == true:
			print("hola")
			var state_machine = uicontroller.find_child("StateMachine")
			state_machine.change_to("auto_baul")
			pass # Replace with function body.
			#if abierto == false:
				#animando = true
				#anim.play("abrir")
				#await anim.animation_finished
				#animando = false
				#abierto = true
				#print("abierto")
			#else:
				#animando = true
				#anim.play("cerrar")
				#await anim.animation_finished
				#animando = false
				#abierto = false
				#print("cerrado")
