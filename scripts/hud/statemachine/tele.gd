extends UIState

@export var hud_principal: Control
@export var hud_elementos: Control
@export var hud_startday: Control
@export var hud_yes_no: Control
@export var hud_inspecion: Control

@onready var startdaymanager: Node = $"../../../Startdaymanager"

@export var Star_Day_rect: TextureRect
@export var skip_intro: Button

func enter() -> void:
	if fsm.debug == true:
		print("ENTER TELE")
	if hud_startday:
		hud_startday.show()
	# Aquí podrías poner el foco en el primer botón para soporte de joystick

func exit() -> void:
	if fsm.debug == true:
		print("EXIT TELE")
	if hud_startday:
		hud_startday.hide()

# Ejemplo de transición por input (ej: presionar Start/Esc para pausar)
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and GameManager.paused == false:
		fsm.change_to("Pause")

func _on_skip_pressed() -> void:
	Star_Day_rect.visible = true
	skip_intro.visible = false
	startdaymanager.skip = true

func _on_button_empezar_dia_pressed() -> void:
	fsm.change_to("main_view")
	pass # Replace with function body.
