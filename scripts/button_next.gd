extends Button

@onready var node_main: Node3D = $"../.."

@onready var label: Label = $"../Color"
@onready var fallos_label: Label = $"../Fallos"
@onready var autos_label: Label = $"../Autos"

@onready var auto = preload("res://scenes/car.tscn")
@onready var yes_no_menu: Control = $"../YES_NO_menu"
@onready var inspeccion_menu: Control = $"../Inspeccion_menu"

@onready var papel_patente: Label3D = $"../papel/papel_patente"

@onready var camera_3d: Camera3D = $"../../Camera3D"

@export var max_fallos : int = 999
@export var max_autos: int = 10

@onready var fallos : int = 0
@onready var autos : int = 0

@onready var colors = {
	"rojo": "ff1b13",
	"azul": "222bff",
	"verde": "1df428",
	"violeta": "5510c7",
	"naranja": "f67200",
}

@onready var characters = "ABCDEFGHIJKLMNÑOPQRSTUVWXYZ"

var condicion_dia
var condicion_auto
var auto_dupe

var active = false

func generate_word(chars: String, length: int) -> String:
	var word: String = ""
	var n_char = chars.length()
	for i in range(length):
		word += chars[randi() % n_char]
	return word

func generate_patente():
	#random patente
	
	var patente_adelante = auto_dupe.find_child("patente_adelante")
	var patente_atras = auto_dupe.find_child("patente_atras")
	
	var num_patente1 = randi_range(0,9)
	var num_patente2 = randi_range(0,9)
	var num_patente3 =  randi_range(0,9)
	
	var letras = generate_word(characters,3)
	
	var patente = str(num_patente1,num_patente2,num_patente3," ",letras)
	
	patente_adelante.text = patente
	
	patente_atras.text = patente
	
	var num_correct_paper = randi_range(0,1)
	
	if num_correct_paper == 0:
		print("el papel es verdadero")
	if num_correct_paper == 1:
		print("el papel es falso")
	
	print(patente)
	
	if num_correct_paper == 0:
		#resultado correcto/papeles en regla
		papel_patente.text = patente
	else:
		#papeles erroneos
		var dificultad_papel = randi_range(1,6)
		print("cantidad de errores: ",dificultad_papel)
		var posiciones_errores = [0,1,2,4,5,6]
		
		for i in range(dificultad_papel):
			print(i)
			var error_tipo = randi_range(0,1)
			# 0 es error en 1 numero, 1 es error en 1 letra
			if error_tipo == 0:
				var error_posicion = randi_range(0,2)
				var num = randi_range(0,9)
				posiciones_errores.erase(error_posicion)
				if patente[error_posicion] == str(num):
					i -= 1
					print("paso")
					pass
				var patente_error = patente.substr(0, error_posicion) + patente.substr(error_posicion + 1)
				papel_patente.text = patente_error.insert(error_posicion,str(num))
				patente = papel_patente.text
				print("error de numero: ", num, " posicion: ", error_posicion)
			else:
				var error_posicion = randi_range(4,6)
				var letra = generate_word(characters,1)
				posiciones_errores.erase(error_posicion)
				if patente[error_posicion] == letra:
					i -= 1
					print("paso")
					pass
				var patente_error = patente.substr(0, error_posicion) + patente.substr(error_posicion + 1)
				papel_patente.text = patente_error.insert(error_posicion,str(letra))
				patente = papel_patente.text
				print("error de letra: ", letra, " posicion: ", error_posicion)
		#papel_patente.text = str(num_patente1,num_patente2,num_patente3," ",letras)
	
func _ready() -> void:
	
	#random color
	var num = randi_range(0,4)
	condicion_dia = colors.values()[num]
	label.text += str(colors.keys()[num])
	fallos_label.text = str("Fallos: ",fallos," / ",max_fallos)
	autos_label.text = str("Autos: ",autos," / ",max_autos)
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fallos >= max_fallos:
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	if autos >= max_autos:
		get_tree().change_scene_to_file("res://scenes/victoria.tscn")
	pass

func _on_pressed() -> void:
	if get_meta("Auto_on") == false:
		set_meta("Auto_on", true)
		
		#random color
		
		var num_color = randi_range(0,4)
		
		auto_dupe = auto.instantiate()
		
		var materiall = auto_dupe.get_active_material(0).duplicate()
		materiall.albedo_color = Color(colors.values()[num_color])
		auto_dupe.set_surface_override_material(0, materiall)
		condicion_auto = colors.values()[num_color]
		node_main.add_child(auto_dupe)
		auto_dupe.global_position = Vector3(0.2,0,-2.0)
		
		generate_patente()
		
		camera_3d.rotation = Vector3(0,deg_to_rad(45),0)
		
		await get_tree().create_timer(0.2).timeout
		
		yes_no_menu.visible = true
		
		
	else:
		print("ya hay pasajero")
		pass
	


func _on_yes_pressed() -> void:
	if active == false:
		active = true
		auto_dupe.irse()
		await get_tree().create_timer(3.0).timeout
		autos += 1
		if condicion_auto == condicion_dia:
			fallos += 1
		auto_dupe.queue_free()
		set_meta("Auto_on", false)
		yes_no_menu.visible = false
		fallos_label.text = str("Fallos: ",fallos," / ",max_fallos)
		autos_label.text = str("Autos: ",autos," / ",max_autos)
		active = false
	pass # Replace with function body.

func _on_no_pressed() -> void:
	if active == false:
		active = true
		if condicion_auto != condicion_dia:
			fallos += 1
		auto_dupe.queue_free()
		set_meta("Auto_on", false)
		yes_no_menu.visible = false
		fallos_label.text = str("Fallos: ",fallos," / ",max_fallos)
		autos_label.text = str("Autos: ",autos," / ",max_autos)
		active = false
	pass # Replace with function body.


func _on_inspeccion_pressed() -> void:
	if get_meta("inspeccion_menu_on") == false:
		set_meta("inspeccion_menu_on", true)
		yes_no_menu.visible = false
		inspeccion_menu.visible = true
	else:
		camera_3d.rotation = Vector3(0,deg_to_rad(45),0)
		camera_3d.position = Vector3(1.8,0.7,1.5)
		set_meta("inspeccion_menu_on", false)
		yes_no_menu.visible = true
		inspeccion_menu.visible = false
	pass # Replace with function body.


func _on_inspeccion_adelante_pressed() -> void:
	camera_3d.rotation = Vector3(0,deg_to_rad(0),0)
	camera_3d.position = auto_dupe.find_child("camara_patente_adelante").global_position
	pass # Replace with function body.


func _on_inspeccion_atras_pressed() -> void:
	camera_3d.rotation = Vector3(0,deg_to_rad(180),0)
	camera_3d.position = auto_dupe.find_child("camara_patente_atras").global_position
	pass # Replace with function body.
