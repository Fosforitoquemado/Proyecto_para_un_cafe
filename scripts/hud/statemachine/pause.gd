extends UIState

@export var hud_principal: Control 
@onready var state_machine: Node = $".."

func enter() -> void:
	if GameManager.paused == false:
		get_tree().paused = true
	if hud_principal:
		hud_principal.show()
	# Aquí podrías poner el foco en el primer botón para soporte de joystick

func exit() -> void:
	if hud_principal:
		hud_principal.hide()
	if GameManager.paused == false:
		get_tree().paused = false

# Ejemplo de transición por input (ej: presionar Start/Esc para pausar)
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and GameManager.paused == false:
		fsm.back()


func _on_button_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().quit()
	pass # Replace with function body.


func _on_button_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/hud/menu.tscn")
	pass # Replace with function body.
