extends Control

@export var label_dia: Label
@export var label_dinero: Label

@onready var sub_viewport_container: SubViewportContainer = $"SubViewportContainer"

@onready var day_manager: Node = $DayManager

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	if label_dia:
		var savedata = SaveLoad.contents_to_save
		label_dia.text = str("DIA: ",savedata.values()[0] + 1)
		label_dinero.text = str("DINERO: ",savedata.values()[1])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _input(event: InputEvent) -> void:
	var savedata = SaveLoad.contents_to_save
	if event.is_action_pressed("ui_down"):
		await get_tree().physics_frame
		label_dinero.text = str("DINERO: ",savedata.values()[1])
	if event.is_action_pressed("ui_up"):
		await get_tree().physics_frame
		label_dia.text = str("DIA: ",savedata.values()[0] + 1)


func _on_reset_file_pressed() -> void:
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
	pass # Replace with function body.


func _on_comprar_pressed() -> void:
	if SaveLoad.contents_to_save.values()[1] >= 2000.0:
		SaveLoad.contents_to_save["dinero"] = snapped(SaveLoad.contents_to_save.values()[1] - 2000.0, 0.01)
		SaveLoad._save()
		sub_viewport_container.star()
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
