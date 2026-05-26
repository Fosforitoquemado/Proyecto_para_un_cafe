extends UIState

@export var HUD: Control
@export var hud_elementos: Control 
@onready var state_machine: Node = $".."
@export var timer: ProgressBar
@export var siguiente: TextureRect

@onready var CameraController: Node = $"../../../CameraController"

var auto_on = false

func enter() -> void:
	if hud_elementos:
		HUD.update_ui()
		GameManager.check_estado()
	# Aquí podrías poner el foco en el primer botón para soporte de joystick

func exit() -> void:
	pass

# Ejemplo de transición por input (ej: presionar Start/Esc para pausar)
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		fsm.change_to("Pause")
