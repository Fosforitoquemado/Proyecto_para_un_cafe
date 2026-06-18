extends UIState

@export var tutorial_scene: PackedScene

@export var HUD: Control
@export var hud_inspeccion: Control
@export var baul_menu: Control
@export var baul_boton: Button
@onready var state_machine: Node = $".."

@onready var CameraController: Node = $"../../../CameraController"

var baul_abierto = false
var baul_activo = false

var tutorial_hecho = false

func comenzar_guia():
	var instancia_tutorial = tutorial_scene.instantiate()
	add_child(instancia_tutorial)
	
	# Definimos los pasos: qué botón explicar y qué decir
	var configuracion_tutorial = [
		{
			"nodo_boton": baul_boton,
			"automatico": false,
			"texto": "algunos objetos del baul se pueden abrir/interactuar (pueden tener cosas)."
		},
	]
	var configuracion_posiciones = [
		{
			"direccion": "arriba",
			"pixeles_x": 100,
			"pixeles_y": 100
		},
	]
	# Arrancamos el sistema
	instancia_tutorial.iniciar_tutorial(configuracion_tutorial,configuracion_posiciones)

func enter() -> void:
	if tutorial_hecho == false:
		tutorial_hecho = SaveLoad.contents_to_save["tutorial_baul_brillo"]
	if hud_inspeccion:
		CameraController.ver_baul(GameManager.auto_dupe.find_child("camara_baul").global_position,GameManager.auto_dupe.find_child("camara_baul").rotation)
		var daymanager = get_tree().get_first_node_in_group("DayManager")
		var dia = daymanager.get_day()
		if "objetos_baul" in dia.documentos_habilitados:
			if tutorial_hecho == false:
				await  get_tree().create_timer(0.2,false).timeout
				comenzar_guia()
				SaveLoad.contents_to_save["tutorial_baul_brillo"] = true
				SaveLoad._save()
		if baul_abierto == false and not baul_activo:
			state_machine.processing = true
			baul_abierto = true
			baul_activo = true
			GameManager.auto_dupe.abrir_baul()
			await get_tree().create_timer(2, false).timeout
			baul_activo = false
			baul_menu.show()
			state_machine.processing = false
		hud_inspeccion.show()
	# Aquí podrías poner el foco en el primer botón para soporte de joystick

func exit() -> void:
	if hud_inspeccion:
		if baul_abierto == true and not baul_activo:
			baul_abierto = false
			baul_activo = true
			hud_inspeccion.hide()
			baul_menu.hide()
			state_machine.processing = true
			GameManager.auto_dupe.cerrar_baul()
			await get_tree().create_timer(2, false).timeout
			baul_activo = false
			state_machine.processing = false
			

func _on_cerrar_baul_pressed() -> void:
	if hud_inspeccion:
		if baul_abierto == true and not baul_activo:
			baul_abierto = false
			baul_activo = true
			hud_inspeccion.hide()
			baul_menu.hide()
			state_machine.processing = true
			GameManager.auto_dupe.cerrar_baul()
			await get_tree().create_timer(2, false).timeout
			baul_activo = false
			state_machine.processing = false
	state_machine.change_to("auto_atras")
	pass # Replace with function body.

# Ejemplo de transición por input (ej: presionar Start/Esc para pausar)
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and GameManager.paused == false:
		fsm.change_to("Pause")
