extends Node

@export var Autos: Dictionary
@export var Colors: Dictionary
@export var Nombres: Array
@export var Apellidos: Array

var characters = "ABCDEFGHIJKLMNÑOPQRSTUVWXYZ"

#elementos auto
@onready var autos_lista = {
	"fiat 147": preload("res://scenes/autos/147.tscn"),
	"suran": preload("res://scenes/autos/suran.tscn"),
	"fiat doblo": preload("res://scenes/autos/fiat doblo.tscn"),
	"ford escort": preload("res://scenes/autos/escort.tscn"),
	"c4 lunge": preload("res://scenes/autos/c_4_lunge.tscn")
}

@onready var colors = {
	"rojo": "ff1b13",
	"azul": "222bff",
	"verde": "1df428",
	"violeta": "5510c7",
	"naranja": "f67200",
	"blanco": "dedede",
	"negro": "05040b"
}

@onready var Nombres_lista = [
	"Benjamín",
	"Delfina",
	"Nicolás",
	"Federico",
	"Juan",
	"Tomás"
]

@onready var apellidos_lista = [
	"Martinez",
	"Sánchez",
	"Ferrero",
	"Fort",
	"Pereira",
	"miameee"
]

var _auto_data: Dictionary

func generate_modelo():
	var num_auto_random = randi_range(0,autos_lista.size() - 1)
	var auto = autos_lista.values()[num_auto_random]
	var modelo_info = {
		"auto": auto,
		"num_auto": num_auto_random
	}

	return modelo_info
func generate_color():
	var num_color = randi_range(0,colors.size() - 1)
	var color = colors.values()[num_color]
	var color_info = {
		"color": color,
		"num_color": num_color
	}

	return color_info
func generate_patente() -> String:
	#random patente
	var num_patente1 = randi_range(0,9)
	var num_patente2 = randi_range(0,9)
	var num_patente3 =  randi_range(0,9)
	
	var letras = Utils.random_string(characters,3)
	var patente = str(num_patente1,num_patente2,num_patente3," ",letras)
	
	return patente
func generate_VTV() -> int:
	var vtv = randi_range(1,12)
	return vtv
func generate_numero_licencia() -> int:
	#random numero_licencia
	var num = randi_range(10000000,99999999)
	return num
func generate_nombre() -> int:
	var nombre = randi_range(0,Nombres_lista.size() - 1)
	return nombre
func generate_apellido() -> int:
	var apellido = randi_range(0,apellidos_lista.size() - 1)
	return apellido
func generate_fecha_nacimiento() -> Dictionary:
	var mes := randi_range(1, 12)
	var dia := Utils.dias_en_mes(mes)
	dia = randi_range(1, dia)
	var anio := randi_range(1945, 2008)
	var nacimiento = {
		"dia": dia,
		"mes": mes,
		"anio": anio
	}
	return nacimiento
func generate_fecha_vencimiento() -> String:
	var vencimiento = Utils.generar_fecha(2026,2030)
	return vencimiento

func _generate_auto() -> Dictionary:
	var data = {}
	
	# BASE
	var patente = generate_patente()
	var color_info = generate_color()
	var modelo_info = generate_modelo()
	var vtv = generate_VTV()
	var nombre = generate_nombre()
	var apellido = generate_apellido()
	var licencia = generate_numero_licencia()
	var nacimiento = generate_fecha_nacimiento()
	
	# DOCUMENTOS
	var fecha_cedula = generate_fecha_vencimiento()
	var fecha_licencia = generate_fecha_vencimiento()
	
	# RESULTADO
	data = {
		"patente": patente,
		"nombre": nombre,
		"apellido": apellido,
		"nacimiento": nacimiento,
		"color_info": color_info,
		"modelo_info": modelo_info,
		"vtv": vtv,
		"N Licencia": licencia,
		"fecha_cedula": fecha_cedula,
		"fecha_licencia": fecha_licencia
	}
	_auto_data = data
	print("AUTO GENERADO")
	return data
