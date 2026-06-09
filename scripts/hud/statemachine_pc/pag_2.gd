extends UIState

@onready var state_machine: Node = $".."

@export var page:Control

@export var PCCONTROL:Control

@onready var libro_guia: AnimatedSprite2D = $"../../PanelContainer_instrucciones/libro_guia"

var busy = false

func enter() -> void:
	if fsm.debug == true:
		print("ENTER ",name)
	page.show()
	pass
	# Aquí podrías poner el foco en el primer botón para soporte de joystick

func exit() -> void:
	if fsm.debug == true:
		print("EXIT ",name)
	page.hide()
	busy = false
	print("BUSYYY")
	pass

# Ejemplo de transición por input (ej: presionar Start/Esc para pausar)
func handle_input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_cancel") and GameManager.paused == false:
		#fsm.change_to("Pause")
	pass


func _on_button_flecha_derecha_pressed() -> void:
	if PCCONTROL.pag_number < PCCONTROL.max_pag_number and busy == false:
		busy = true
		PCCONTROL.pag_number += 1
		libro_guia.speed_scale = 1
		page.hide()
		libro_guia.play("default")
		await libro_guia.animation_finished
		print(PCCONTROL.pag_number)
		print("name",name)
		fsm.change_to(str("pag",PCCONTROL.pag_number))
	pass # Replace with function body.


func _on_button_flecha_izquierda_pressed() -> void:
	if PCCONTROL.pag_number > PCCONTROL.min_pag_number and busy == false:
		busy = true
		PCCONTROL.pag_number -= 1
		libro_guia.speed_scale = -1
		page.hide()
		libro_guia.play("default")
		await libro_guia.animation_finished
		print(PCCONTROL.pag_number)
		print("name",name)
		fsm.change_to(str("pag",PCCONTROL.pag_number))
	pass # Replace with function body.
