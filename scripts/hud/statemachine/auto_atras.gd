extends UIState
@export var tutorial_scene: PackedScene

@export var HUD: Control
@export var hud_inspeccion: Control
@export var baul_boton: Button
@onready var state_machine: Node = $".."

@onready var CameraController: Node = $"../../../CameraController"

var tutorial_hecho = false

func comenzar_guia():
	var instancia_tutorial = tutorial_scene.instantiate()
	add_child(instancia_tutorial)
	
	# Definimos los pasos: qué botón explicar y qué decir
	var configuracion_tutorial = [
		{
			"nodo_boton": baul_boton,
			"texto": "¡clickea el baul para examinar su interior."
		},
	]
	var configuracion_posiciones = [
		{
			"direccion": "abajo",
			"pixeles_x": 100,
			"pixeles_y": 100
		},
	]
	# Arrancamos el sistema
	instancia_tutorial.iniciar_tutorial(configuracion_tutorial,configuracion_posiciones)

func enter() -> void:
	if tutorial_hecho == false:
		var savedata = SaveLoad.contents_to_save
		tutorial_hecho = savedata.values()[4]
	if hud_inspeccion:
		CameraController.ver_patente_atras(GameManager.auto_dupe.find_child("camara_patente_atras").global_position)
		hud_inspeccion.show()
		var daymanager = get_tree().get_first_node_in_group("DayManager")
		var dia = daymanager.get_day()
		if "objetos_baul" in dia.documentos_habilitados:
			if tutorial_hecho == false:
				await  get_tree().create_timer(0.2).timeout
				comenzar_guia()
				SaveLoad.contents_to_save["tutorial_baul"] = true
				SaveLoad._save()
	# Aquí podrías poner el foco en el primer botón para soporte de joystick

func exit() -> void:
	if hud_inspeccion:
		hud_inspeccion.hide()

func _on_inspeccion_volver_pressed() -> void:
	fsm.change_to("yes_no_menu")
	pass # Replace with function body.

# Ejemplo de transición por input (ej: presionar Start/Esc para pausar)
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and GameManager.paused == false:
		fsm.change_to("Pause")
