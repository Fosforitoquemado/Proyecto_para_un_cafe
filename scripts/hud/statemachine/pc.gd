extends UIState

@export var tutorial_scene: PackedScene

@export var hud_elementos: Control
@export var hud_inspeccion: Control
@onready var state_machine: Node = $".."

@export var baul_boton: Button

var tutorial_hecho = false

func comenzar_guia():
	var instancia_tutorial = tutorial_scene.instantiate()
	add_child(instancia_tutorial)
	
	# Definimos los pasos: qué botón explicar y qué decir
	var configuracion_tutorial = [
		{
			"nodo_boton": baul_boton,
			"texto": "¡clickea la base de datos para checkear."
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
		tutorial_hecho = savedata.values()[5]
	if hud_elementos:
		hud_elementos.hide()
		hud_inspeccion.hide()
		if tutorial_hecho == false:
			await get_tree().create_timer(3.2).timeout
			comenzar_guia()
			SaveLoad.contents_to_save["tutorial_pc"] = true
			SaveLoad._save()
	# Aquí podrías poner el foco en el primer botón para soporte de joystick

func exit() -> void:
	if hud_elementos:
		hud_elementos.show()
	pass

# Ejemplo de transición por input (ej: presionar Start/Esc para pausar)
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and GameManager.paused == false:
		fsm.change_to("Pause")
	
