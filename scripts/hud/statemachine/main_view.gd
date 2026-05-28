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
		auto_on = false
		siguiente.visible = true
		HUD.update_ui()
		CameraController.vista_normal()
		hud_elementos.show()
	# Aquí podrías poner el foco en el primer botón para soporte de joystick

func exit() -> void:
	pass

# Ejemplo de transición por input (ej: presionar Start/Esc para pausar)
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		fsm.change_to("Pause")

func _on_button_siguiente_pressed() -> void:
	siguiente.visible = false
	if auto_on == false:
		GameManager.generar_auto()
	state_machine.change_to("transicion")
