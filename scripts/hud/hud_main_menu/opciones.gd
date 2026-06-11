extends Control

@export var tutorial_scene: PackedScene

@export var hud_opciones: Control 
@export var boton_opciones:TextureRect
@onready var state_machine: Node = $".."

@export var pantalla: OptionButton
@export var vsync: OptionButton
@export var slider_volumen: HSlider

## Ejemplo de transición por input (ej: presionar Start/Esc para pausar)
#func handle_input(event: InputEvent) -> void:
	#if event.is_action_pressed("ui_cancel"):
		#fsm.change_to("Pause")

func _ready() -> void:
	update_ui()

func update_ui():
	#opciones
	pantalla.select(SaveLoad.contents_to_save.values()[8])
	vsync.select(SaveLoad.contents_to_save.values()[9])
	slider_volumen.value = SaveLoad.contents_to_save.values()[10]

func _on_modo_pantalla_item_selected(index: int) -> void:
	print(DisplayServer.window_get_mode())
	match index:
		0:DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		1:DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	SaveLoad.contents_to_save["pantalla_modo"] = index
	print(SaveLoad.contents_to_save.values()[8])
	print(DisplayServer.window_get_mode())
	SaveLoad._save()
	pass # Replace with function body.

func _on_vsync_item_selected(index: int) -> void:
	match index:
		0:DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		1:DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	print(SaveLoad.contents_to_save.values()[9]," ",index)
	SaveLoad.contents_to_save["vsync"] = index
	SaveLoad._save()
	print(SaveLoad.contents_to_save.values()[9])
	pass # Replace with function body.

func _on_button_reiniciar_pressed() -> void:
	SaveLoad.contents_to_save["pantalla_modo"] = 0
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	SaveLoad.contents_to_save["vsync"] = 0
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	SaveLoad.contents_to_save["volumen"] = 2.5
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(
		bus_index,
		linear_to_db(2.5))
	SaveLoad._save()
	update_ui()
	pass # Replace with function body.

func _on_slider_opciones_drag_ended(value_changed: bool) -> void:
	var bus_index = AudioServer.get_bus_index("Master")
	
	# Convertir 0-100 a decibeles
	if slider_volumen.value == 0:
		AudioServer.set_bus_volume_db(bus_index, -80)
		SaveLoad.contents_to_save["volumen"] = -80
	else:
		AudioServer.set_bus_volume_db(
			bus_index,
			linear_to_db(slider_volumen.value)
		)
		print("volumen sldierrrr",slider_volumen.value)
		SaveLoad.contents_to_save["volumen"] = slider_volumen.value
	SaveLoad._save()
	pass # Replace with function body.


func _on_button_atras_pressed() -> void:
	hud_opciones.hide()
	boton_opciones.show()
	pass # Replace with function body.
