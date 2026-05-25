extends UIState

@export var tutorial_scene: PackedScene

@export var hud_inspeccion: Control 
@onready var state_machine: Node = $".."

@export var vtv: Button
@export var delante: Button
@export var atras: Button
@export var mesa: Button
@export var volver: Button

var tutorial_hecho = false

func comenzar_guia():
	var instancia_tutorial = tutorial_scene.instantiate()
	add_child(instancia_tutorial)
	
	# Definimos los pasos: qué botón explicar y qué decir
	var configuracion_tutorial = [
		{
			"nodo_boton": vtv,
			"texto": "¡Este es el botón para inspeccionar la vtv."
		},
		{
			"nodo_boton": delante,
			"texto": "¡Este es el botón para inspeccionar el auto adelante"
		},
		{
			"nodo_boton": atras,
			"texto": "¡Este es el botón para inspeccionar el auto atras"
		},
		{
			"nodo_boton": mesa,
			"texto": "¡Este es el botón para ver la mesa y los documentos"
		},
		{
			"nodo_boton": volver,
			"texto": "¡Este es el botón para volver al menu anterior"
		}
	]
	var configuracion_posiciones = [
		{
			"direccion": "izq",
			"pixeles_x": 100,
			"pixeles_y": 100
		},
		{
			"direccion": "izq",
			"pixeles_x": 100,
			"pixeles_y": 100
		},
		{
			"direccion": "izq",
			"pixeles_x": 100,
			"pixeles_y": 100
		},
		{
			"direccion": "izq",
			"pixeles_x": 100,
			"pixeles_y": 100
		},
		{
			"direccion": "izq",
			"pixeles_x": 100,
			"pixeles_y": 100
		},
		{
			"direccion": "izq",
			"pixeles_x": 100,
			"pixeles_y": 100
		},
	]
	# Arrancamos el sistema
	instancia_tutorial.iniciar_tutorial(configuracion_tutorial,configuracion_posiciones)

func enter() -> void:
	if hud_inspeccion:
		if tutorial_hecho == false:
			var savedata = SaveLoad.contents_to_save
			tutorial_hecho = savedata.values()[3]
		hud_inspeccion.show()
		if tutorial_hecho == false:
			await  get_tree().create_timer(0.2).timeout
			comenzar_guia()
			SaveLoad.contents_to_save["tutorial_inspeccion"] = true
			SaveLoad._save()
	# Aquí podrías poner el foco en el primer botón para soporte de joystick

func exit() -> void:
	pass

func _on_inspeccion_volver_pressed() -> void:
	hud_inspeccion.hide()
	fsm.change_to("yes_no_menu")
	pass # Replace with function body.

func _on_inspeccion_atras_pressed() -> void:
	fsm.change_to("auto_atras")
	pass # Replace with function body.

func _on_inspeccion_vtv_pressed() -> void:
	fsm.change_to("auto_vtv")
	pass # Replace with function body.

func _on_inspeccion_mesa_pressed() -> void:
	fsm.change_to("mesa")

func _on_inspeccion_delantera_pressed() -> void:
	fsm.change_to("auto_adelante")
	pass # Replace with function body.


func _on_inspeccion_compu_pressed() -> void:
	pass # Replace with function body.

# Ejemplo de transición por input (ej: presionar Start/Esc para pausar)
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		fsm.change_to("Pause")
