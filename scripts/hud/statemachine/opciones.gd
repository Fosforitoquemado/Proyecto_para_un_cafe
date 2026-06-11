extends UIState

@export var tutorial_scene: PackedScene

@export var HUD: Control
@export var hud_opciones: Control 
@onready var state_machine: Node = $".."

@export var pantalla: OptionButton
@export var vsync: OptionButton
@export var slider_opciones: HSlider

var tutorial_hecho = false

func enter() -> void:
	if hud_opciones:
		hud_opciones.show()
		SaveLoad.contents_to_save["tutorial_inspeccion"] = true
		SaveLoad._save()
	# Aquí podrías poner el foco en el primer botón para soporte de joystick

func exit() -> void:
	if hud_opciones:
		hud_opciones.hide()
	GameManager.paused = false
	pass

# Ejemplo de transición por input (ej: presionar Start/Esc para pausar)
func handle_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		fsm.change_to("Pause")

func _on_slider_opciones_drag_ended(value_changed: bool) -> void:
	var bus_index = AudioServer.get_bus_index("Master")
	
	# Convertir 0-100 a decibeles
	if slider_opciones.value == 0:
		AudioServer.set_bus_volume_db(bus_index, -80)
		SaveLoad.contents_to_save["volumen"] = -80
	else:
		AudioServer.set_bus_volume_db(
			bus_index,
			linear_to_db(slider_opciones.value)
		)
		print("volumen sldierrrr",slider_opciones.value)
		SaveLoad.contents_to_save["volumen"] = slider_opciones.value
		SaveLoad._save()
	pass # Replace with function body.

func _on_modo_pantalla_item_selected(index: int) -> void:
	print(DisplayServer.window_get_mode())
	match index:
		0:DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		1:DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	SaveLoad.contents_to_save["pantalla_modo"] = index
	SaveLoad._save()
	pass # Replace with function body.

func _on_vsync_item_selected(index: int) -> void:
	match index:
		0:DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		1:DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	print(SaveLoad.contents_to_save.values()[9]," ",index)
	SaveLoad.contents_to_save["vsync"] = index
	SaveLoad._save()
	print(DisplayServer.window_get_vsync_mode())
	pass # Replace with function body.

func _on_button_reiniciar_pressed() -> void:
	SaveLoad.contents_to_save["pantalla_modo"] = 0
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	SaveLoad.contents_to_save["vsync"] = 0
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	SaveLoad.contents_to_save["volumen"] = 0.25
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(0.25))
	SaveLoad._save()
	HUD.update_ui()
	pass # Replace with function body.

func _on_button_atras_pressed() -> void:
	fsm.change_to("Pause")
	pass # Replace with function body.
