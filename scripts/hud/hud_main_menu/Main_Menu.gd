extends Control

@export var label_dia: Label
@export var label_dinero: Label
@export var comprar_boton:TextureRect
@export var jugar_boton:TextureRect
@export var reset_boton:TextureRect
@export var quit_boton:TextureRect
@export var configurar_boton:TextureRect
@export var ayuda:TextureRect

@export var animationplayer:AnimationPlayer

@onready var sub_viewport_container: SubViewportContainer = $"SubViewportContainer"
@onready var reset_confirmacion: Control = $reset_confirmacion

@export var configuracion:Control

@onready var day_manager: Node = $DayManager

var botones_index = 0
var botones = []
var ocupado = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if jugar_boton:
		jugar_boton.show()
		botones.append(jugar_boton)
		botones.append(comprar_boton)
		botones.append(reset_boton)
		botones.append(configurar_boton)
		botones.append(ayuda)
		botones.append(quit_boton)
		
	var index_fullscreen = SaveLoad.contents_to_save.values()[8]
	match index_fullscreen:
		0:DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		1:DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	var index_vsync = SaveLoad.contents_to_save.values()[9]
	match index_vsync:
		0:DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		1:DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
	var bus_index = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(
			bus_index,
			linear_to_db(SaveLoad.contents_to_save.values()[10])
		)
	print("screen ",DisplayServer.window_get_mode(),"vsync ",DisplayServer.window_get_vsync_mode(),"volumen ",AudioServer.get_bus_volume_db(AudioServer.get_bus_index("Master")))
	if configuracion:
		configuracion.hide()
	if label_dia:
		var savedata = SaveLoad.contents_to_save
		label_dia.text = str("DIA: ",savedata.values()[0] + 1)
		label_dinero.text = str("DINERO: ",savedata.values()[1])
	pass # Replace with function body.

func _input(event: InputEvent) -> void:
	var savedata = SaveLoad.contents_to_save
	
	if event.is_action_pressed("rueda_mouse_arriba"):
		if botones_index < botones.size() - 1 and ocupado == false:
			ocupado = true
			botones[botones_index].show()
			botones[botones_index + 1].show()
			botones[botones_index + 1].rotation = deg_to_rad(-180)
			animationplayer.play("new_animation_2")
			var tween = create_tween()
			tween.tween_property(botones[botones_index],"rotation",deg_to_rad(180),(animationplayer.get_animation("new_animation").length / 1.5))
			var tween2 = create_tween()
			tween2.tween_property(botones[botones_index + 1],"rotation",deg_to_rad(0),(animationplayer.get_animation("new_animation").length / 1.5))
			await get_tree().create_timer(animationplayer.get_animation("new_animation").length + 0.05).timeout
			botones[botones_index].hide()
			botones[botones_index].rotation = 0
			if botones_index < botones.size() - 1:
				botones_index += 1
			ocupado = false
	if event.is_action_pressed("rueda_mouse_abajo") and ocupado == false:
		if botones_index > 0:
			ocupado = true
			botones[botones_index].show()
			botones[botones_index - 1].show()
			botones[botones_index - 1].rotation = deg_to_rad(180)
			animationplayer.play("new_animation_2")
			var tween = create_tween()
			tween.tween_property(botones[botones_index],"rotation",deg_to_rad(-180),(animationplayer.get_animation("new_animation").length / 1.5))
			var tween2 = create_tween()
			tween2.tween_property(botones[botones_index - 1],"rotation",deg_to_rad(0),(animationplayer.get_animation("new_animation").length / 1.5))
			await get_tree().create_timer(animationplayer.get_animation("new_animation").length + 0.05).timeout
			botones[botones_index].hide()
			botones[botones_index].rotation = 0
			if botones_index > 0:
				botones_index -= 1
			ocupado = false
	
	if event.is_action_pressed("ui_down"):
		await get_tree().physics_frame
		label_dinero.text = str("DINERO: ",savedata.values()[1])
	if event.is_action_pressed("ui_up"):
		await get_tree().physics_frame
		label_dia.text = str("DIA: ",savedata.values()[0] + 1)

func _on_no_pressed() -> void:
	reset_confirmacion.hide()
	pass # Replace with function body.

func _on_si_pressed() -> void:
	SaveLoad.contents_to_save["dinero"] = 0
	SaveLoad.contents_to_save["day"] = 0
	SaveLoad.contents_to_save["tutorial_yes_no"] = false
	SaveLoad.contents_to_save["tutorial_inspeccion"] = false
	SaveLoad.contents_to_save["tutorial_pc"] = false
	SaveLoad.contents_to_save["tutorial_baul"] = false
	SaveLoad.contents_to_save["usos_mate"] = 3
	SaveLoad._save()
	
	label_dia.text = str("DIA: ",1)
	label_dinero.text = str("DINERO: ",0)
	
	reset_confirmacion.hide()
	pass # Replace with function body.

func _on_reset_file_pressed() -> void:
	reset_confirmacion.show()
	pass # Replace with function body.

func _on_comprar_pressed() -> void:
	if SaveLoad.contents_to_save.values()[1] >= 2000.0:
		SaveLoad.contents_to_save["dinero"] = snapped(SaveLoad.contents_to_save.values()[1] - 2000.0, 0.01)
		SaveLoad._save()
		#sub_viewport_container.star()
	pass # Replace with function body.

func _on_jugar_pressed() -> void:
	get_tree().change_scene_to_file(day_manager.dias[SaveLoad.contents_to_save.values()[0]].mapa[0])
	pass # Replace with function body.

func _on_button_quit_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.

func _on_next_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/hud/tuto_2.tscn")
	pass # Replace with function body.

func _on_help_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/hud/tuto_1.tscn")
	pass # Replace with function body.

func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/hud/menu.tscn")
	pass # Replace with function body.

func _on_configuracion_pressed() -> void:
	configuracion.show()
	configurar_boton.hide()
	pass # Replace with function body.

func _on_record_pressed() -> void:
	get_tree().change_scene_to_file(day_manager.dias[7].mapa[0])
	pass # Replace with function body.
