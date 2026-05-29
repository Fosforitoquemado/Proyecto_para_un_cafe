extends UIState

@export var HUD: Control
@export var hud_inspeccion: Control 
@onready var state_machine: Node = $".."

@onready var CameraController: Node = $"../../../CameraController"

func enter() -> void:
	if hud_inspeccion:
		CameraController.ver_vtv(GameManager.auto_dupe.find_child("camara_VTV").global_position)
		print(GameManager.auto_dupe.find_child("camara_VTV").global_position)
		hud_inspeccion.show()
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
