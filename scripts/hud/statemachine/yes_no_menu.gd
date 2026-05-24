extends UIState

@export var HUD:Control
@export var yes_no_menu: Control 
@onready var state_machine: Node = $".."
@export var timer: ProgressBar
@onready var mate: Node3D = $"../../../Elementos_mesa/MATE"

@onready var CameraController: Node = $"../../../CameraController"

var active = false

func enter() -> void:
	if yes_no_menu:
		CameraController.vista_normal()
		yes_no_menu.show()
	# Aquí podrías poner el foco en el primer botón para soporte de joystick

func exit() -> void:
	if yes_no_menu:
		yes_no_menu.hide()

func _on_yes_pressed() -> void:
	if active == false:
		active = true
		HUD.auto_on = false
		GameManager.ida_auto()
		timer._stop_timer()
		yes_no_menu.hide()
		var animator = GameManager.auto_dupe.find_child("AnimationPlayer")
		await get_tree().create_timer(animator.current_animation_length).timeout
		if DocumentosGenerator.auto_ilegal == true:
			GameManager.sumar_fallo()
			print("FALLASTE❌❌")
		else:
			GameManager.sumar_dinero_jugador(50)
			GameManager.sumar_auto()
			print("BIEN✅✅")
		active = false
		fsm.change_to("main_view")
		

func _on_no_pressed() -> void:
	if active == false:
		active = true
		HUD.auto_on = false
		GameManager.ida_auto()
		timer._stop_timer()
		yes_no_menu.hide()
		var animator = GameManager.auto_dupe.find_child("AnimationPlayer")
		await get_tree().create_timer(animator.current_animation_length).timeout
		if DocumentosGenerator.auto_ilegal == false:
			print("FALLASTE❌❌")
			GameManager.sumar_fallo()
		else:
			GameManager.sumar_dinero_jugador(50)
			print("BIEN✅✅")
		active = false
		fsm.change_to("main_view")

func _on_coimear_pressed() -> void:
	if active == false:
		active = true
		timer._stop_timer()
		yes_no_menu.hide()
		if DocumentosGenerator.auto_ilegal == false:
			print("FALLASTE❌❌")
			GameManager.sumar_fallo()
		else:
			GameManager.sumar_dinero_jugador(AutoGenerator._auto_data["dinero_coima"])
			print("BIEN✅✅")
		GameManager.auto_dupe.queue_free()
		active = false
		fsm.change_to("main_view")

func _on_mate_pressed() -> void:
	mate._on_mate_pressed()
	pass # Replace with function body.

# Ejemplo de transición por input (ej: presionar Start/Esc para pausar)
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		fsm.change_to("Pause")


func _on_inspeccion_pressed() -> void:
	fsm.change_to("inspeccion")
	pass # Replace with function body.
