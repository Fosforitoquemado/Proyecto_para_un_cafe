extends UIState

@export var tutorial_scene: PackedScene

@export var aprobado: Button
@export var multar: Button
@export var tomar_mate: Button
@export var inspeccionar: Button
@export var coima: Button
@export var pc: Button

@export var HUD:Control
@export var yes_no_menu: Control 
@onready var state_machine: Node = $".."
@export var timer: ProgressBar
@onready var mate: Node3D = $"../../../Elementos_mesa/MATE"

@onready var CameraController: Node = $"../../../CameraController"

var active = false

var tutorial_hecho = false

func comenzar_guia():
	var instancia_tutorial = tutorial_scene.instantiate()
	add_child(instancia_tutorial)
	
	# Definimos los pasos: qué botón explicar y qué decir
	var configuracion_tutorial = [
		{
			"nodo_boton": aprobado,
			"texto": "¡Este es el botón de aprobado! Úsalo para dejar pasar autos."
		},
		{
			"nodo_boton": multar,
			"texto": "¡Este es el botón de multar! Úsalo para multar autos"
		},
		{
			"nodo_boton": tomar_mate,
			"texto": "¡Este es el botón para tomar mate, usalo cuando tu baara de tiempo pase el 30%"
		},
		{
			"nodo_boton": pc,
			"texto": "¡Este es la pc, clickeala cuadno quieras y necesites verificar informacion del vehiculo"
		},
		{
			"nodo_boton": inspeccionar,
			"texto": "¡Este es el botón de inspeccionar, usalo para revisar y avlidar los autos"
		},
		{
			"nodo_boton": coima,
			"texto": "¡Este es el botón para coimear, cuando veas la oportunidad de cerrar un trato, hacelo"
		}
	]
	var configuracion_posiciones = [
		{
			"direccion": "arriba",
			"pixeles_x": 100,
			"pixeles_y": 100
		},
		{
			"direccion": "arriba",
			"pixeles_x": 100,
			"pixeles_y": 100
		},
		{
			"direccion": "arriba",
			"pixeles_x": 100,
			"pixeles_y": 100
		},
		{
			"direccion": "pixeles",
			"pixeles_x": 0,
			"pixeles_y": -150
		},
		{
			"direccion": "arriba",
			"pixeles_x": 100,
			"pixeles_y": 100
		},
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
	if tutorial_hecho == false:
		var savedata = SaveLoad.contents_to_save
		tutorial_hecho = savedata.values()[2]
	if yes_no_menu:
		CameraController.vista_normal()
		yes_no_menu.show()
		
		if tutorial_hecho == false:
			await  get_tree().process_frame
			comenzar_guia()
			SaveLoad.contents_to_save["tutorial_yes_no"] = true
			SaveLoad._save()
		timer._start_timer()
	# Aquí podrías poner el foco en el primer botón para soporte de joystick

func exit() -> void:
	if yes_no_menu:
		yes_no_menu.hide()

func _on_yes_pressed() -> void:
	if active == false:
		active = true
		HUD.auto_on = false
		GameManager.ida_auto()
		timer._stop_timer()
		yes_no_menu.hide()
		if DocumentosGenerator.auto_ilegal == true:
			GameManager.sumar_fallo()
			print("FALLASTE❌❌")
		else:
			GameManager.sumar_dinero_jugador(50)
			GameManager.sumar_auto()
			print("BIEN✅✅")
		active = false
		HUD.auto_out = false
		state_machine.change_to("transicion")

func _on_no_pressed() -> void:
	if active == false:
		active = true
		HUD.auto_on = false
		GameManager.ida_auto()
		timer._stop_timer()
		yes_no_menu.hide()
		if DocumentosGenerator.auto_ilegal == false:
			print("FALLASTE❌❌")
			GameManager.sumar_fallo()
		else:
			GameManager.sumar_dinero_jugador(50)
			print("BIEN✅✅")
		active = false
		HUD.auto_out = false
		state_machine.change_to("transicion")

func _on_coimear_pressed() -> void:
	if active == false:
		active = true
		HUD.auto_on = false
		GameManager.ida_auto()
		timer._stop_timer()
		yes_no_menu.hide()
		if DocumentosGenerator.ilegalidades <= 1:
			print("FALLASTE❌❌")
			GameManager.sumar_fallo()
		else:
			GameManager.sumar_dinero_jugador(AutoGenerator._auto_data["dinero_coima"] * DocumentosGenerator.ilegalidades)
			print("BIEN✅✅")
		active = false
		HUD.auto_out = false
		state_machine.change_to("transicion")

func _on_mate_pressed() -> void:
	mate._on_mate_pressed()
	pass # Replace with function body.

# Ejemplo de transición por input (ej: presionar Start/Esc para pausar)
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		fsm.change_to("Pause")

func _on_inspeccion_pressed() -> void:
	fsm.change_to("inspeccion")
	pass # Replace with function body.
