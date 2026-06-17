extends UIState

@export var tutorial_scene: PackedScene

@onready var DocumentosGenerator: Node = $"../../../DocumentosGenerator"

@export var aprobado: Button
@export var multar: Button
@export var tomar_mate: Button
@export var inspeccionar: Button
@export var coima: Button
@export var pc: Button
@export var reloj: Button

@export var porcentaje = 30

@export var HUD:Control
@export var yes_no_menu: Control 
@export var timer: ProgressBar
@export var progressbarmate: ProgressBar
@onready var usos_mate_num: Label = $"../../YES_NO_menu/ProgressBar_mate/usos_mate_num"
@onready var mate: Node3D = $"../../../Elementos_mesa/MATE"

@onready var error: AudioStreamPlayer = $"../../Sonidos/Error"
@onready var acierto: AudioStreamPlayer = $"../../Sonidos/acierto"
@onready var cash: AudioStreamPlayer = $"../../Sonidos/cash"
@onready var multado: AudioStreamPlayer = $"../../Sonidos/multado"
@onready var sello: AudioStreamPlayer = $"../../Sonidos/sello"

@onready var state_machine: Node = $".."

@onready var pc_control: Control = $"../../../PCSISTEMA/SubViewport/PCControl"

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
			"automatico": false,
			"texto": "¡Este es el botón de aprobado! Úsalo para dejar pasar autos que no tengan fallos!, te pagaran por cada auto correctamente procesado."
		},
		{
			"nodo_boton": multar,
			"automatico": false,
			"texto": "¡Este es el botón de multar! Úsalo para multar autos con documentos erroneos, te restaran palta por cada auto erroneamente procesado"
		},
		{
			"nodo_boton": reloj,
			"automatico": false,
			"texto": "¡Este es el reloj, cuando llegue a las 17:00 va a sonar y habra concluido el dia!"
		},
		{
			"nodo_boton": tomar_mate,
			"automatico": false,
			"texto": "¡Este es el botón para tomar mate, usalo cuando tu barra de tiempo pase el 30% y recude la barra de tiempo"
		},
		{
			"nodo_boton": pc,
			"automatico": false,
			"texto": "¡Este es la pc, clickeala cuando quieras y necesites verificar informacion del vehiculo"
		},
		{
			"nodo_boton": coima,
			"automatico": false,
			"texto": "¡Este es el botón para coimear, cuando un vehiculo tenga 2 o mas errores aprovechalo para ganar mas plata"
		},
		{
			"nodo_boton": inspeccionar,
			"automatico": false,
			"texto": "¡Este es el botón de inspeccionar, usalo para revisar y validar los autos"
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
	if fsm.debug == true:
		print("ENTER yes_no_menu")
	if tutorial_hecho == false:
		var savedata = SaveLoad.contents_to_save
		tutorial_hecho = savedata.values()[2]
	if yes_no_menu:
		CameraController.vista_normal()
		
		progressbarmate.value = GameManager.usos_mates
		usos_mate_num.text = str(GameManager.usos_mates)
		
		yes_no_menu.show()
		if tutorial_hecho == false:
			comenzar_guia()
			SaveLoad.contents_to_save["tutorial_yes_no"] = true
			SaveLoad._save()
		timer._start_timer()
		GameManager.empezar_dia()
	# Aquí podrías poner el foco en el primer botón para soporte de joystick

func exit() -> void:
	if fsm.debug == true:
		print("EXIT yes no menu")
	if yes_no_menu:
		yes_no_menu.hide()

func _on_yes_pressed() -> void:
	if active == false:
		active = true
		GameManager.ida_auto(0)
		timer._stop_timer()
		yes_no_menu.hide()
		sello.play()
		if DocumentosGenerator.auto_ilegal == true:
			GameManager.sumar_fallo()
			GameManager.update_score(-DocumentosGenerator.auto_data["score_auto"] / 2)
			GameManager.sumar_auto()
			pc_control.agregar_errores(DocumentosGenerator.auto_data["errores"])
			print("FALLASTE❌❌")
			error.play()
		else:
			GameManager.update_score(DocumentosGenerator.auto_data["score_auto"])
			#GameManager.sumar_dinero_jugador(50)
			GameManager.sumar_auto()
			acierto.play()
			print("BIEN✅✅")
		active = false
		HUD.auto_out = false
		state_machine.change_to("transicion")

func _on_no_pressed() -> void:
	if active == false:
		active = true
		GameManager.ida_auto(1)
		timer._stop_timer()
		yes_no_menu.hide()
		sello.play()
		if DocumentosGenerator.auto_ilegal == false:
			print("FALLASTE❌❌")
			error.play()
			GameManager.sumar_fallo()
			GameManager.update_score(-DocumentosGenerator.auto_data["score_auto"] / 2)
			GameManager.sumar_auto()
			pc_control.agregar_errores(["el auto tenia todo en regla ❌"])
		else:
			GameManager.update_score(DocumentosGenerator.auto_data["score_auto"])
			#GameManager.sumar_dinero_jugador(50)
			GameManager.sumar_auto()
			acierto.play()
			multado.play()
			print("BIEN✅✅")
		active = false
		HUD.auto_out = false
		state_machine.change_to("transicion")

func _on_coimear_pressed() -> void:
	if active == false:
		active = true
		timer._stop_timer()
		yes_no_menu.hide()
		sello.play()
		if DocumentosGenerator.ilegalidades <= 1:
			print("FALLASTE❌❌")
			error.play()
			GameManager.ida_auto(0)
			GameManager.sumar_fallo()
			GameManager.update_score(-DocumentosGenerator.auto_data["score_auto"] * 2)
			GameManager.sumar_auto()
			pc_control.agregar_errores([str("el auto tenia solo ",DocumentosGenerator.ilegalidades," ilegalidades ❌")])
		else:
			GameManager.ida_auto(2)
			GameManager.update_score(DocumentosGenerator.auto_data["score_auto"] * 2)#DocumentosGenerator.ilegalidades)
			#GameManager.sumar_dinero_jugador(AutoGenerator._auto_data["dinero_coima"] * DocumentosGenerator.ilegalidades)
			GameManager.sumar_auto()
			acierto.play()
			cash.play()
			print("BIEN✅✅")
		active = false
		HUD.auto_out = false
		state_machine.change_to("transicion")

func _on_mate_pressed() -> void:
	if active == false and timer.value >= ((timer.max_value * porcentaje) / 100) and GameManager.usos_mates > 0:
		active = true
		mate.tomar_mate()
		timer._pause_timer()
		await  get_tree().create_timer(4,false).timeout
		timer._reduce_timer(((timer.max_value * porcentaje) / 100) * 1.5)
		timer._start_timer()
		GameManager.usos_mates -= 1
		usos_mate_num.text = str(GameManager.usos_mates)
		progressbarmate.value = GameManager.usos_mates
		active = false
	pass # Replace with function body.

func _on_inspeccion_pressed() -> void:
	fsm.change_to("inspeccion")
	pass # Replace with function body.
	
func ocultar_progressbarmate():
	progressbarmate.hide()
	
func mostrar_progressbarmate():
	progressbarmate.show()

func tiempo_fuera():
	if active == false:
		active = true
		GameManager.ida_auto(0)
		timer._stop_timer()
		yes_no_menu.hide()
		print("FALLASTE❌❌")
		error.play()
		GameManager.sumar_fallo()
		GameManager.update_score(-DocumentosGenerator.auto_data["score_auto"] / 2)
		GameManager.sumar_auto()
		pc_control.agregar_errores(["el chofer se canso de esperar ❌"])
		active = false
		HUD.auto_out = false
		state_machine.change_to("transicion")

# Ejemplo de transición por input (ej: presionar Start/Esc para pausar)
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and GameManager.paused == false:
		fsm.change_to("Pause")
