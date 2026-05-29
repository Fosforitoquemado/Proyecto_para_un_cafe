extends Node

@export var max_fallos := 333
@export var max_autos := 5

@export var sub_viewport_container: SubViewportContainer

var fallos: int = 0
var autos_pasados: int = 0
var dinero_player

var usos_mates = 3

var empezar_tiempo = false
var tiempo_dia_total = 400.0
var tiempo = 0.0

var score = 0.0

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

func _process(delta: float) -> void:
	var uicontroller
	uicontroller = get_tree().get_first_node_in_group("ui_manager")
	if empezar_tiempo == true:
		tiempo += delta
	if tiempo >= tiempo_dia_total and uicontroller.auto_on == false:
		finalizar_dia()
		print("fallos",fallos,"max_fallos",max_fallos)
		get_tree().change_scene_to_file("res://scenes/hud/victoria.tscn")

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

func empezar_dia():
	var daymanager = get_tree().get_first_node_in_group("DayManager")
	var dia = daymanager.get_day()
	var uicontroller
	uicontroller = get_tree().get_first_node_in_group("ui_manager")
	tiempo_dia_total = dia.tiempo_dia
	empezar_tiempo = true

func finalizar_dia():
	empezar_tiempo = false
	var daymanager = get_tree().get_first_node_in_group("DayManager")
	daymanager.sumar_dia()
	SaveLoad.contents_to_save["dinero"] = dinero_player
	SaveLoad.contents_to_save["day"] = daymanager.dia_actual
	SaveLoad.contents_to_save["usos_mate"] = usos_mates
	SaveLoad._save()
	reset()

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
	
	var personaje_data = auto_data["personaje_info"]
	var personaje = personaje_data["personaje"].instantiate()
	var nodo_personaje = auto_dupe.find_child("nodo_personaje")
	nodo_personaje.add_child(personaje)
	
	#mostrar elementos
	elementos_mesa.mostrar_datos()

func ida_auto(condicion):
	var elementos_mesa = get_tree().get_first_node_in_group("elementos_mesa")
	elementos_mesa.ocultar_documentos(condicion)

func reset():
	tiempo = 0.0
	fallos = 0
	var uicontroller
	uicontroller = get_tree().get_first_node_in_group("ui_manager")
	autos_pasados = 0

func sumar_dinero_jugador(dinero):
	print("dinero_antes: ",dinero_player)
	dinero_player += dinero
	print("dinero_ahora: ",dinero_player)

func sumar_fallo():
	fallos += 1

func sumar_auto():
	autos_pasados += 1

func update_score(score_auto):
	score += score_auto
	print(score)

#func check_estado():
	#if fallos >= max_fallos:
		#reset()
		#print("fallos",fallos,"max_fallos",max_fallos)
		#get_tree().change_scene_to_file("res://scenes/hud/game_over.tscn")
	#elif autos_pasados >= max_autos:
		#reset()
		#var daymanager = get_tree().get_first_node_in_group("DayManager")
		#daymanager.sumar_dia()
		#SaveLoad.contents_to_save["dinero"] = dinero_player
		#SaveLoad.contents_to_save["day"] = daymanager.dia_actual
		#SaveLoad._save()
		#print("fallos",fallos,"max_fallos",max_fallos)
		#get_tree().change_scene_to_file("res://scenes/hud/victoria.tscn")
