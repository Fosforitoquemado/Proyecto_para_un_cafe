extends UIState

@export var hud_principal: Control 
@onready var state_machine: Node = $".."

@export var animationplayer:AnimationPlayer

var back_ready = false

func enter() -> void:
	back_ready = false
	if GameManager.paused == false:
		get_tree().paused = true
	if hud_principal:
		hud_principal.show()
		animationplayer.play("move")
	# Aquí podrías poner el foco en el primer botón para soporte de joystick

func exit() -> void:
	if hud_principal:
		hud_principal.hide()
	if GameManager.paused == false:
		get_tree().paused = false

# Ejemplo de transición por input (ej: presionar Start/Esc para pausar)
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and GameManager.paused == false and back_ready == false:
		back_ready = true
		animationplayer.play("atras")
		await get_tree().create_timer(animationplayer.get_animation("atras").length).timeout 
		fsm.back()
		pass

func _on_button_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().quit()
	pass # Replace with function body.

func _on_button_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/hud/menu.tscn")
	GameManager.empezar_tiempo = false
	pass # Replace with function body.

func _on_button_resume_pressed() -> void:
	if back_ready == false:
		back_ready = true
		animationplayer.play("atras")
		await get_tree().create_timer(animationplayer.get_animation("atras").length).timeout 
		fsm.back()
	pass # Replace with function body.
