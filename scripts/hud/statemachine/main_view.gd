extends UIState

@export var HUD: Control
@export var hud_elementos: Control 
@onready var state_machine: Node = $".."
@export var timer: ProgressBar
@export var siguiente: TextureRect

@onready var CameraController: Node = $"../../../CameraController"

@onready var pc_control: Control = $"../../../PCSISTEMA/SubViewport/PCControl"

func enter() -> void:
	if fsm.debug == true:
		print("ENTER MAINVIEW")
	if hud_elementos:
		siguiente.visible = true
		HUD.update_ui()
		CameraController.vista_normal()
		hud_elementos.show()
	# Aquí podrías poner el foco en el primer botón para soporte de joystick

func exit() -> void:
	if fsm.debug == true:
		print("EXIT MAINVIEW")
	pass

# Ejemplo de transición por input (ej: presionar Start/Esc para pausar)
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and GameManager.paused == false:
		fsm.change_to("Pause")

func _on_button_siguiente_pressed() -> void:
	siguiente.visible = false
	HUD.auto_called = true
	GameManager.generar_auto()
	pc_control.borrar_errores()
	state_machine.change_to("transicion")
