extends UIState

@export var tutorial_scene: PackedScene

@export var comprar_mate: Button
@export var mates_usos: Label
@export var HUD_tienda:Control
@export var tienda: Control
@export var coste_mate: Label
@export var dinero: Label
@export var dinero_ganado_hoy: Label
@export var autos_pasados: Label
@export var autos_fallados: Label
@onready var state_machine: Node = $".."

var active = false

var tutorial_hecho = false

func comenzar_guia():
	var instancia_tutorial = tutorial_scene.instantiate()
	add_child(instancia_tutorial)
	
	# Definimos los pasos: qué botón explicar y qué decir
	var configuracion_tutorial = [
		{
			"nodo_boton": comprar_mate,
			"texto": "¡Este es el botón para comprar mates"
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
	# Esperamos un momento o lo activamos cuando empiece la partida
	if fsm.debug == true:
		print("ENTER tienda")
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if tutorial_hecho == false:
		var savedata = SaveLoad.contents_to_save
		tutorial_hecho = savedata.values()[2]
	if tienda:
		mates_usos.text = str("MATES: ",GameManager.usos_mates)
		coste_mate.text = str("CUESTA: ", 100)
		dinero.text = str("DINERO: ",GameManager.dinero)
		dinero_ganado_hoy.text = str("DINERO GANADO HOY: ",GameManager.dinero_ganado_hoy)
		autos_pasados.text = str("AUTOS REVISADOS HOY: ",GameManager.autos_pasados)
		autos_fallados.text = str("AUTOS FALLADOS: ",GameManager.fallos)
		
		tienda.show()
		if tutorial_hecho == false:
			comenzar_guia()
			SaveLoad.contents_to_save["tutorial_yes_no"] = true
			SaveLoad._save()
	# Aquí podrías poner el foco en el primer botón para soporte de joystick

func exit() -> void:
	if fsm.debug == true:
		print("EXIT tienda")
	if tienda:
		tienda.hide()

# Ejemplo de transición por input (ej: presionar Start/Esc para pausar)
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and GameManager.paused == false:
		fsm.change_to("Pause")

func _on_comprar_pressed() -> void:
	if GameManager.usos_mates < 3:
		if GameManager.dinero >= 100:
			GameManager.dinero -= 100
			GameManager.usos_mates += 1
			dinero.text = str("DINERO: ",GameManager.dinero)
			mates_usos.text = str("MATES: ",GameManager.usos_mates)
			print("mate_comprado")
	#GUARDAR AL SALIR
	pass # Replace with function body.

func _on_siguiente_dia_pressed() -> void:
	var daymanager = get_tree().get_first_node_in_group("DayManager")
	daymanager.sumar_dia()
	SaveLoad.contents_to_save["dinero"] = GameManager.dinero
	SaveLoad.contents_to_save["day"] = daymanager.dia_actual
	SaveLoad.contents_to_save["usos_mate"] = GameManager.usos_mates
	SaveLoad._save()
	GameManager.reset()
	get_tree().change_scene_to_file(daymanager.dias[SaveLoad.contents_to_save.values()[0]].mapa[0])
	pass # Replace with function body.
