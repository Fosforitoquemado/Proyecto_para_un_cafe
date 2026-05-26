extends UIState

@export var HUD: Control
@export var hud_inspeccion: Control
@onready var pc_mesa: Control = $"../../Inspeccion_menu/pc_mesa"

@onready var pcsistema: PCStatic = $"../../../PCSISTEMA"

@onready var state_machine: Node = $".."
@onready var camara_mesa: Node3D = $"../../../Elementos_mesa/mesa/Camara_mesa"

@onready var CameraController: Node = $"../../../CameraController"

func enter() -> void:
	if hud_inspeccion:
		CameraController.ver_escritorio(camara_mesa.global_position)
		hud_inspeccion.show()
		pc_mesa.show()
	# Aquí podrías poner el foco en el primer botón para soporte de joystick

func exit() -> void:
	if hud_inspeccion:
		hud_inspeccion.hide()
		pc_mesa.hide()

func _on_inspeccion_volver_pressed() -> void:
	fsm.change_to("yes_no_menu")
	pass # Replace with function body.

# Ejemplo de transición por input (ej: presionar Start/Esc para pausar)
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		fsm.change_to("Pause")


func _on_button_ir_pc_pressed() -> void:
	fsm.change_to("pc")
	pcsistema.camara()
	pcsistema.toggle_use()
	pass # Replace with function body.
