extends UIState

@onready var pc_control: Control = $"../.."
@onready var state_machine: Node = $".."
@onready var libro_guia: AnimatedSprite2D = $"../../PanelContainer_instrucciones/libro_guia"

func enter() -> void:
	if fsm.debug == true:
		print("ENTER TRANSCICION")
	await libro_guia.animation_finished
	state_machine.change_to(str("pag", pc_control.pag_number))
	pass
	# Aquí podrías poner el foco en el primer botón para soporte de joystick

func exit() -> void:
	if fsm.debug == true:
		print("EXIT trancision")
	pc_control.busy = false
	pass

# Ejemplo de transición por input (ej: presionar Start/Esc para pausar)
func handle_input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_cancel") and GameManager.paused == false:
		#fsm.change_to("Pause")
	pass
