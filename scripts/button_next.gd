extends Button

@onready var node_main: Node3D = $"../.."

@onready var camera_3d: Camera3D = $"../../Camera3D"

#posicion camara
@onready var camara_mesa: Node3D = $"../Camara_mesa"


#elementos HUD
@onready var fallos_label: Label = $"../Fallos"
@onready var autos_label: Label = $"../Autos"
@onready var timer: ProgressBar = $"../Timer"
@onready var fecha_label: Label = $"../Fecha"

@onready var yes_no_menu: Control = $"../YES_NO_menu"
@onready var inspeccion_menu: Control = $"../Inspeccion_menu"

#elementos auto
@onready var autos_lista = {
	"fiat 147": preload("res://scenes/autos/147.tscn"),
	"suran": preload("res://scenes/autos/suran.tscn"),
	"fiat doblo": preload("res://scenes/autos/fiat doblo.tscn"),
	"ford escort": preload("res://scenes/autos/escort.tscn")
}

#papel
@onready var papel_patente: Label3D = $"../papel/papel_patente"
@onready var color_papel: Label3D = $"../papel/color_papel"
@onready var vtv_papel: Label3D = $"../papel/VTV_papel"

#cedula
@onready var dominio: Label3D = $"../cedula/Dominio"
@onready var modelo: Label3D = $"../cedula/Modelo"
@onready var vencimiento: Label3D = $"../cedula/Vencimiento"

#max valores
@export var max_fallos : int = 999
@export var max_autos: int = 10

#probabilidades
@export var probabilidad_color: int = 70
@export var probabilidad_patente_papel: int = 70
@export var probabilidad_VTV: int = 70
@export var probabilidad_patente_cedula: int = 70
@export var probabilidad_modelo_cedula: int = 70
@export var probabilidad_fecha_cedula: int = 100
@export var probabilidad_fecha_cedula_2026: int = 50

#valores in-game
@onready var fallos : int = 0
@onready var autos_que_pasaron : int = 0
@onready var fecha : String

@onready var colors = {
	"rojo": "ff1b13",
	"azul": "222bff",
	"verde": "1df428",
	"violeta": "5510c7",
	"naranja": "f67200",
}

@onready var characters = "ABCDEFGHIJKLMNÑOPQRSTUVWXYZ"

var auto_dupe

var active = false
func generate_fecha():
	var mes_30 := [4,6,9,11]
	var mes_31 := [1,3,5,7,8,10,12]
	var dia
	var mes = randi_range(1,12)
	if mes == 2:
		dia = randi_range(1,28)
	if mes in mes_30:
		dia = randi_range(1,30)
	if mes in mes_31:
		dia = randi_range(1,31)
	set_meta("Mes", mes)
	set_meta("Dia", dia)
	fecha = str(dia,"/",mes,"/2026")
func generate_word(chars: String, length: int) -> String:
	var word: String = ""
	var n_char = chars.length()
	for i in range(length):
		word += chars[randi() % n_char]
	return word
	
func generate_VTV():
	var VTV = auto_dupe.find_child("mes_VTV")
	var num = randi_range(1,12)
	VTV.text = str(num)
func generate_VTV_papel():
	var VTV = auto_dupe.find_child("mes_VTV")
	var num_correct_paper = randi_range(0,100)
	
	if num_correct_paper <= probabilidad_VTV:
		#correcto
		
		vtv_papel.text = VTV.text
		#set_meta("Auto_ilegal_bool", false)
		print("la vtv del papel es true")
	else:
		#fake
		var num := randi_range(1, 12 - 1)
		if num >= int(VTV.text):
			num += 1
		vtv_papel.text = str(num)
		set_meta("Auto_ilegal_bool", true)
		print("la vtv del papel es fake")

func generate_patente() -> String:
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
	
	print(patente)
	
	return patente
func generate_papel_patente(patente, label3d, probabilidad):
	var num_correct_paper = randi_range(0,100)
	var posiciones_errores = [0,1,2,4,5,6]
	
	if num_correct_paper <= probabilidad:
		#correcto
		label3d.text = patente
		print("la patente del papel es verdadera")
	else:
		#fake
		print("la patente del papel es falsa")
		set_meta("Auto_ilegal_bool", true)
		
		var dificultad_papel = randi_range(1,7)
		print("cantidad de errores: ",dificultad_papel)
		
		if dificultad_papel == 7:
			#patente total mente distinta
			var num_patente1 = randi_range(0,9)
			var num_patente2 = randi_range(0,9)
			var num_patente3 =  randi_range(0,9)
	
			var letras = generate_word(characters,3)
	
			var patente_R = str(num_patente1,num_patente2,num_patente3," ",letras)
			
			label3d.text = patente_R
			
		else:
			for i in range(dificultad_papel):
				print(i)
				var error_tipo = randi_range(0,1)
				# 0 es error en 1 numero, 1 es error en 1 letra
				if error_tipo == 0:
					var error_posicion = randi_range(0,2)
					posiciones_errores.erase(error_posicion)
					#fake
					var num := randi_range(0, 9 - 1)
					if patente[error_posicion] == str(num):
						num += 1
					var patente_error = patente.substr(0, error_posicion) + patente.substr(error_posicion + 1)
					label3d.text = patente_error.insert(error_posicion,str(num))
					patente = label3d.text
					print("error de numero: ", num, " posicion: ", error_posicion)
				else:
					var error_posicion = randi_range(4,6)
					var letra = generate_word(characters,1)
					posiciones_errores.erase(error_posicion)
					var num := randi_range(0, 9 - 1)
					if patente[error_posicion] == str(num):
						num += 1
					var patente_error = patente.substr(0, error_posicion) + patente.substr(error_posicion + 1)
					label3d.text = patente_error.insert(error_posicion,str(letra))
					patente = label3d.text
					print("error de letra: ", letra, " posicion: ", error_posicion)
				#papel_patente.text = str(num_patente1,num_patente2,num_patente3," ",letras)
func generate_color():
	var num_color = randi_range(0,4)
	#var materiall = auto_dupe.get_active_material(0).duplicate()
	var materiall = auto_dupe.get_active_material(0)
	materiall.albedo_color = Color(colors.values()[num_color])
	auto_dupe.set_surface_override_material(0, materiall)
	
	node_main.add_child(auto_dupe)
	auto_dupe.global_position = Vector3(0.2,0,-2.0)
	return num_color
func generate_color_papel(num_color):
	#random color
	
	var num_correct_paper = randi_range(0,100)
	
	if num_correct_paper <= probabilidad_color:
		#correcto
		
		color_papel.text = str(colors.keys()[num_color])
		#set_meta("Auto_ilegal_bool", true)
		print("el color del papel es true")
	else:
		#fake
		var num := randi_range(0, 4 - 1)
		if num >= num_color:
			num += 1
		color_papel.text = str(colors.keys()[num])
		set_meta("Auto_ilegal_bool", true)
		print("el color del papel es falso")
func generate_modelo_cedula(num_auto, probabilidad):
	var modelo_auto = autos_lista.keys()[num_auto]
	var num_correct_paper = randi_range(0,100)
	
	if num_correct_paper <= probabilidad:
		#correcto
		
		modelo.text = modelo_auto
		#set_meta("Auto_ilegal_bool", false)
		print("el modelo de la cedula es verdad")
	else:
		#fake
		var num := randi_range(0, autos_lista.size() - 2)
		if num >= num_auto:
			num += 1
		modelo_auto = autos_lista.keys()[num]
		modelo.text = modelo_auto
		set_meta("Auto_ilegal_bool", true)
		print("el modelo de la cedula es fake")
func generate_fecha_cedula(probabilidad, probabilidad_2026):
	var num_correct_paper = randi_range(0,100)
	var num_correct_paper_2026 = randi_range(0,100)
	
	if num_correct_paper <= probabilidad:
		#correcto
		var mes_30 := [4,6,9,11]
		var mes_31 := [1,3,5,7,8,10,12]
		var dia
		var mes = randi_range(1,12)
		if mes == 2:
			dia = randi_range(1,28)
		if mes in mes_30:
			dia = randi_range(1,30)
		if mes in mes_31:
			dia = randi_range(1,31)
		var fecha_dia_mes = str(dia,"/",mes,"/20")
		var anio = randi_range(27,34)
		vencimiento.text = fecha_dia_mes + str(anio)
		#set_meta("Auto_ilegal_bool", false)
		print("la fecha de la cedula esta bien")
	else:
		if num_correct_paper_2026 <= probabilidad_2026:
			#fake
			var num_dia_o_mes = randi_range(0,100)
			var probabilidad_dia = 50
			if num_dia_o_mes <= probabilidad_dia:
				#dia fake
				var dia
				var mes = get_meta("Mes")
				dia = randi_range(1,get_meta("Dia") - 1)
				var fecha_dia_mes = str(dia,"/",mes,"/2026")
				vencimiento.text = fecha_dia_mes
				set_meta("Auto_ilegal_bool", true)
				print("la fecha de la cedula esta mal (dia mal)")
			else:
				var mes_30 := [4,6,9,11]
				var mes_31 := [1,3,5,7,8,10,12]
				var dia
				var mes = randi_range(1,get_meta("Mes") - 1)
				if mes == 2:
					dia = randi_range(1,28)
				if mes in mes_30:
					dia = randi_range(1,30)
				if mes in mes_31:
					dia = randi_range(1,31)
				var fecha_dia_mes = str(dia,"/",mes,"/2026")
				vencimiento.text = fecha_dia_mes
				set_meta("Auto_ilegal_bool", true)
				print("la fecha de la cedula esta mal (el mes)")
		else:
			#fake
			var mes_30 := [4,6,9,11]
			var mes_31 := [1,3,5,7,8,10,12]
			var dia
			var mes = randi_range(1,12)
			if mes == 2:
				dia = randi_range(1,28)
			if mes in mes_30:
				dia = randi_range(1,30)
			if mes in mes_31:
				dia = randi_range(1,31)
			var fecha_dia_mes = str(dia,"/",mes,"/20")
			var anio = randi_range(14,25)
			vencimiento.text = fecha_dia_mes + str(anio)
			set_meta("Auto_ilegal_bool", true)
			print("la fecha de la cedula esta mal")
func _ready() -> void:
	generate_fecha()
	fecha_label.text = fecha
	fallos_label.text = str("Fallos: ",fallos," / ",max_fallos)
	autos_label.text = str("Autos: ",autos_que_pasaron," / ",max_autos)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fallos >= max_fallos:
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	if autos_que_pasaron >= max_autos:
		get_tree().change_scene_to_file("res://scenes/victoria.tscn")
	pass

func _on_pressed() -> void:
	if get_meta("Auto_on") == false:
		set_meta("Auto_on", true)
		set_meta("Auto_ilegal_bool", false)
		
		timer._start_timer()
		
		var num_auto_random = randi_range(0,autos_lista.size() - 1)
		var auto = autos_lista.values()[num_auto_random]
		
		auto_dupe = auto.instantiate()
		
		var num_color = generate_color()
		generate_color_papel(num_color)
		
		var patente = generate_patente()
		#genero la patente del papel
		generate_papel_patente(patente, papel_patente, probabilidad_patente_papel)
		#genero la patente de la cedula azul
		generate_papel_patente(patente, dominio, probabilidad_patente_cedula)
		
		generate_VTV()
		generate_VTV_papel()
		
		generate_modelo_cedula(num_auto_random, probabilidad_modelo_cedula)
		
		generate_fecha_cedula(probabilidad_fecha_cedula, probabilidad_fecha_cedula_2026)
		camera_3d.rotation = Vector3(0,deg_to_rad(45),0)
		
		visible = false
		
		await get_tree().create_timer(0.2).timeout
		
		yes_no_menu.visible = true
		
	else:
		print("ya hay pasajero")
		pass
	
func _on_yes_pressed() -> void:
	if active == false:
		active = true
		auto_dupe.irse()
		timer._stop_timer()
		yes_no_menu.visible = false
		await get_tree().create_timer(3.0).timeout
		autos_que_pasaron += 1
		if get_meta("Auto_ilegal_bool") == true:
			fallos += 1
		auto_dupe.queue_free()
		set_meta("Auto_on", false)
		visible = true
		fallos_label.text = str("Fallos: ",fallos," / ",max_fallos)
		autos_label.text = str("Autos: ",autos_que_pasaron," / ",max_autos)
		active = false
	pass # Replace with function body.
func _on_no_pressed() -> void:
	if active == false:
		active = true
		timer._stop_timer()
		if get_meta("Auto_ilegal_bool") == false:
			fallos += 1
		auto_dupe.queue_free()
		set_meta("Auto_on", false)
		yes_no_menu.visible = false
		visible = true
		fallos_label.text = str("Fallos: ",fallos," / ",max_fallos)
		autos_label.text = str("Autos: ",autos_que_pasaron," / ",max_autos)
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
		camera_3d.fov = 75
		yes_no_menu.visible = true
		inspeccion_menu.visible = false
		set_meta("inspeccion_menu_on", false)
	pass # Replace with function body.


func _on_inspeccion_adelante_pressed() -> void:
	camera_3d.rotation = Vector3(0,deg_to_rad(0),0)
	camera_3d.position = auto_dupe.find_child("camara_patente_adelante").global_position
	pass # Replace with function body.


func _on_inspeccion_atras_pressed() -> void:
	camera_3d.rotation = Vector3(0,deg_to_rad(180),0)
	camera_3d.position = auto_dupe.find_child("camara_patente_atras").global_position
	pass # Replace with function body.


func _on_inspeccion_vtv_pressed() -> void:
	camera_3d.rotation = Vector3(0,deg_to_rad(0),0)
	camera_3d.position = auto_dupe.find_child("camara_VTV").global_position
	pass # Replace with function body.


func _on_inspeccion_mesa_pressed() -> void:
	camera_3d.rotation = Vector3(deg_to_rad(-90),deg_to_rad(90),0)
	camera_3d.position = camara_mesa.global_position
	pass # Replace with function body.


func _on_fov_slider_value_changed(value: float) -> void:
	camera_3d.fov = 75 - value
	pass # Replace with function body.
