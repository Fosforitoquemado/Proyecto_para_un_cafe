extends UIState

@export var hud_elementos: Control 
@onready var state_machine: Node = $".."

func enter() -> void:
	pass
	if hud_elementos:
		hud_elementos.hide()
	# Aquí podrías poner el foco en el primer botón para soporte de joystick

func exit() -> void:
	if hud_elementos:
		hud_elementos.show()
	pass

# Ejemplo de transición por input (ej: presionar Start/Esc para pausar)
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		fsm.change_to("pause")
	
