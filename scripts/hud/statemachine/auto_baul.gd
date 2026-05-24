extends UIState

@export var HUD: Control
@export var hud_inspeccion: Control
@export var baul_menu: Control
@export var baul_boton: Button
@onready var state_machine: Node = $".."

@onready var CameraController: Node = $"../../../CameraController"

var baul_abierto = false
var baul_activo = false

func enter() -> void:
	if hud_inspeccion:
		CameraController.ver_baul(GameManager.auto_dupe.find_child("camara_baul").global_position,GameManager.auto_dupe.find_child("camara_baul").rotation)
		if baul_abierto == false and not baul_activo:
			baul_abierto = true
			baul_activo = true
			GameManager.auto_dupe.abrir_baul()
			await get_tree().create_timer(2, false).timeout
			baul_activo = false
			baul_menu.show()
		pass # Replace with function body.
		hud_inspeccion.show()
	# Aquí podrías poner el foco en el primer botón para soporte de joystick

func exit() -> void:
	if hud_inspeccion:
		if baul_abierto == true and not baul_activo:
			baul_abierto = false
			baul_activo = true
			GameManager.auto_dupe.cerrar_baul()
			await get_tree().create_timer(2, false).timeout
			baul_activo = false
			baul_menu.hide()

func _on_cerrar_baul_pressed() -> void:
	if baul_abierto == true and not baul_activo:
		baul_abierto = false
		baul_activo = true
		GameManager.auto_dupe.cerrar_baul()
		await get_tree().create_timer(2, false).timeout
		baul_activo = false
		baul_menu.hide()
	pass # Replace with function body.

# Ejemplo de transición por input (ej: presionar Start/Esc para pausar)
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		fsm.change_to("Pause")
