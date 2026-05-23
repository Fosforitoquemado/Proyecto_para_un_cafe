extends Area3D

var ocupado = false

@onready var pcsistema: PCStatic = $".."

var uicontroller

func _ready() -> void:
	uicontroller = get_tree().get_first_node_in_group("ui_manager")
	pass # Replace with function body.

func _input_event(camera, event, position, normal, shape_idx):
	if ocupado:
		return
	if event is InputEventMouseButton:
		
		if event.pressed and uicontroller.auto_on == true:
			print("COMPUTADORA")
			uicontroller._ocultar_menu()
			pcsistema.camara()
			pcsistema.toggle_use()
			
			
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
