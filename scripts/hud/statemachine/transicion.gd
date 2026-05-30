extends UIState

@onready var state_machine: Node = $".."

func enter() -> void:
	if fsm.debug == true:
		print("ENTER TRANSCICION")
	pass
	# Aquí podrías poner el foco en el primer botón para soporte de joystick

func exit() -> void:
	if fsm.debug == true:
		print("EXIT trancision")
	pass

# Ejemplo de transición por input (ej: presionar Start/Esc para pausar)
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and GameManager.paused == false:
		fsm.change_to("Pause")
