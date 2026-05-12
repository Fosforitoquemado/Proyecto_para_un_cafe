extends Node

@export var max_fallos := 333
@export var max_autos := 5

@export var sub_viewport_container: SubViewportContainer

var fallos: int = 0
var autos_pasados: int = 0
var dinero_player

var tiempo_transcurrido = 0

var auto_dupe
var auto_data: Dictionary

func _ready():
	var textura_cursor = load("res://texture/hud/otros/puntero.png")
	var savedata = SaveLoad.contents_to_save
	dinero_player = savedata.values()[1]
	Input.set_custom_mouse_cursor(
		textura_cursor,
		Input.CURSOR_ARROW,
	)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_down"):
		print("dinerillo")
		SaveLoad.contents_to_save["dinero"] = SaveLoad.contents_to_save.values()[1] + 1000
		SaveLoad._save()
	if event.is_action_pressed("ui_up"):
		print("dia_up")
		SaveLoad.contents_to_save["day"] = SaveLoad.contents_to_save.values()[0] + 1
		SaveLoad._save()

func _physics_process(delta: float) -> void:
	tiempo_transcurrido += delta
	if tiempo_transcurrido > 1:
		tiempo_transcurrido = 0
		var num = randi_range(0, 300)
		#if num == 69:
		if num == -1:
			if sub_viewport_container:
				
				sub_viewport_container.visible = true
				sub_viewport_container.star()
		else:
			pass

func generar_auto():
	var elementos_mesa = get_tree().get_first_node_in_group("elementos_mesa")
	auto_data = AutoGenerator._generate_auto()
	
	var auto_modelo_info = auto_data["modelo_info"]
	var color_info = auto_data["color_info"]
	
	auto_dupe = auto_modelo_info["auto"].instantiate()
	var materiall = auto_dupe.get_active_material(0)
	materiall.albedo_color = Color(color_info["color"])
	auto_dupe.set_surface_override_material(0, materiall)
	
	var root = get_node("/root/Main")
	
	root.add_child(auto_dupe)
	auto_dupe.global_position = Vector3(0.2,0,-2.0)
	#mostrar elementos
	elementos_mesa.mostrar_datos()

func reset():
	fallos = 0
	autos_pasados = 0

func sumar_dinero_jugador(dinero):
	print("dinero_antes: ",dinero_player)
	dinero_player += dinero
	print("dinero_ahora: ",dinero_player)

func sumar_fallo():
	fallos += 1

func sumar_auto():
	autos_pasados += 1

func check_estado():
	if fallos >= max_fallos:
		get_tree().change_scene_to_file("res://scenes/hud/game_over.tscn")
		fallos = 0
	elif autos_pasados >= max_autos:
		SaveLoad.contents_to_save["dinero"] = dinero_player
		var daymanager = get_tree().get_first_node_in_group("DayManager")
		daymanager.sumar_dia()
		SaveLoad.contents_to_save["day"] = daymanager.dia_actual
		SaveLoad._save()
		get_tree().change_scene_to_file("res://scenes/hud/victoria.tscn")
		autos_pasados = 0
