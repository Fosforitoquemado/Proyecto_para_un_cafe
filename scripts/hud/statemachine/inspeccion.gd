extends UIState

@export var hud_inspeccion: Control 
@onready var state_machine: Node = $".."

func enter() -> void:
	if hud_inspeccion:
		hud_inspeccion.show()
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
