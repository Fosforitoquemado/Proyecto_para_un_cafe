extends Node

@export var max_fallos := 333
@export var max_autos := 5

@export var sub_viewport_container: SubViewportContainer

var paused = false

var fallos: int = 0
var autos_pasados: int = 0
var dinero = 0
var dinero_ganado_hoy = 0

var max_mates: int = 3
var usos_mates: int = 0

var dia_empezado = false
var empezar_tiempo = false
var tiempo_dia_total = 400.0
var tiempo = 0.0

var tiempo_transcurrido_foxy = 0

var dia

var auto_dupe
var auto_data: Dictionary

func _ready():
	var textura_cursor = load("res://texture/hud/otros/puntero.png")
	var savedata = SaveLoad.contents_to_save
	dinero = savedata.values()[1]
	usos_mates = savedata.values()[6]
	Input.set_custom_mouse_cursor(
		textura_cursor,
		Input.CURSOR_ARROW,
	)

func _process(delta: float) -> void:
	var uicontroller
	uicontroller = get_tree().get_first_node_in_group("ui_manager")
	if empezar_tiempo == true:
		tiempo += delta
	if tiempo >= tiempo_dia_total:
		empezar_tiempo = false
	if uicontroller:
		if tiempo >= tiempo_dia_total and uicontroller.auto_on == false and dia_empezado == true:
			if dinero >= dia.dinero_objetivo:
				dia_empezado = false
				var pantalla_negra = uicontroller.find_child("pantalla_negro")
				pantalla_negra.oscurecer(4)
				await get_tree().create_timer(5).timeout
				get_tree().change_scene_to_file("res://scenes/final_dia.tscn")
			else:
				dia_empezado = false
				var pantalla_negra = uicontroller.find_child("pantalla_negro")
				pantalla_negra.oscurecer(4)
				await get_tree().create_timer(5).timeout
				get_tree().change_scene_to_file("res://scenes/bad_ending.tscn")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_down"):
		print("dinerillo")
		SaveLoad.contents_to_save["dinero"] = SaveLoad.contents_to_save.values()[1] + 1000
		SaveLoad._save()
	if event.is_action_pressed("ui_up"):
		print("dia_up")
		SaveLoad.contents_to_save["day"] = SaveLoad.contents_to_save.values()[0] + 1
		SaveLoad._save()
	if event.is_action_pressed("ui_accept"):
		Engine.time_scale = 20
	elif event.is_action_released("ui_accept"):
		Engine.time_scale = 1

func _physics_process(delta: float) -> void:
	tiempo_transcurrido_foxy += delta
	if tiempo_transcurrido_foxy > 1:
		tiempo_transcurrido_foxy = 0
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
	dia = daymanager.get_day()
	tiempo_dia_total = dia.tiempo_dia
	empezar_tiempo = true
	dia_empezado = true

func generar_auto():
	var elementos_mesa = get_tree().get_first_node_in_group("elementos_mesa")
	auto_data = AutoGenerator._generate_auto()
	
	var auto_modelo_info = auto_data["modelo_info"]
	var color_info = auto_data["color_info"]
	
	auto_dupe = auto_modelo_info["auto"].instantiate()
	var materiall = auto_dupe.get_active_material(0)
	materiall.albedo_color = Color(color_info["color"])
	auto_dupe.set_surface_override_material(0, materiall)
	
	var root = get_tree().current_scene
	
	root.add_child(auto_dupe)
	auto_dupe.global_position = Vector3(0.2,0,-2.0)
	
	var personaje_data = auto_data["personaje_info"]
	var personaje = personaje_data["personaje"].instantiate()
	var torso = personaje.find_child("TORSO")
	var material_personaje = torso.get_active_material(1)
	material_personaje.albedo_color = Color(personaje_data["color"])
	var nodo_personaje = auto_dupe.find_child("nodo_personaje")
	nodo_personaje.add_child(personaje)
	
	#mostrar elementos
	elementos_mesa.mostrar_datos()

func ida_auto(condicion):
	var elementos_mesa = get_tree().get_first_node_in_group("elementos_mesa")
	elementos_mesa.ocultar_documentos(condicion)

func reset():
	tiempo = 0.0
	dinero_ganado_hoy = 0
	fallos = 0
	autos_pasados = 0

func sumar_fallo():
	fallos += 1

func sumar_auto():
	autos_pasados += 1

func update_score(score_auto):
	var dinero_inicial = dinero
	var dinero_final = dinero + score_auto

	var tween = create_tween()
	tween.tween_method(actualizar_dinero, dinero_inicial, dinero_final, 0.5)
	#dinero += score_auto
	dinero_ganado_hoy += score_auto
	print("DINERO: ",dinero)

func actualizar_dinero(valor:float):
	dinero = int(valor)
	var hud = get_tree().get_first_node_in_group("ui_manager")
	hud.update_ui()
