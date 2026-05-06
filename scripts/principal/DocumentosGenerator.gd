extends Node

@export var Config: Dictionary

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

var characters = "ABCDEFGHIJKLMNÑOPQRSTUVWXYZ"
var auto_data: Dictionary
var auto_ilegal: bool = false

#RECORDAR
var fecha_hoy = {
	"dia": 12,
	"mes": 6,
	"anio": 2026
}

func generate_modelo_cedula(probabilidad):
	var auto = auto_data["modelo_info"]
	var num_auto = auto["num_auto"]
	if Utils.chance(probabilidad):
		#correcto
		var modelo_ = autos_lista.values()[num_auto]
		###modelo_cedula.text = modelo_auto
		print("el modelo de la cedula es verdad")
	else:
		#fake
		if Utils.random_excluding(0, autos_lista.size() - 2, num_auto):
			num_auto += 1
		var modelo_ = autos_lista.values()[num_auto]
		###modelo_cedula.text = modelo_auto
		auto_ilegal = true
		print("el modelo de la cedula es fake")

func generate_papel_patente(probabilidad):
	var posiciones_errores = [0,1,2,4,5,6]
	var patente = auto_data["patente"]
	###pcsistema.pc_control.set_dominio(patente)
	if Utils.chance(probabilidad):
		#correcto
		###label3d.text = patente
		print("la patente del papel es verdadera")
	else:
		#fake
		print("la patente del papel es falsa")
		auto_ilegal = true
			
		var dificultad_papel = randi_range(1,7)
		print("cantidad de errores: ",dificultad_papel)
			
		if dificultad_papel == 7:
			#patente total mente distinta
			var num_patente1 = randi_range(0,9)
			var num_patente2 = randi_range(0,9)
			var num_patente3 =  randi_range(0,9)
			
			var letras = Utils.random_string(characters,3)
			patente = str(num_patente1,num_patente2,num_patente3," ",letras)
			
			###label3d.text = patente_R
		else:
			patente = Utils.romper_patente(patente,dificultad_papel)
			#for i in range(dificultad_papel):
				#var error_tipo = randi_range(0,1)
				## 0 es error en 1 numero, 1 es error en 1 letra
				#if error_tipo == 0:
					#var error_posicion = randi_range(0,2)
					#posiciones_errores.erase(error_posicion)
					##fake
					#var num := randi_range(0, 9 - 1)
					#if patente[error_posicion] == str(num):
						#num += 1
					#var patente_error = patente.substr(0, error_posicion) + patente.substr(error_posicion + 1)
					#label3d.text = patente_error.insert(error_posicion,str(num))
					#patente = label3d.text
					#print("error de numero: ", num, " posicion: ", error_posicion)
				#else:
					#var error_posicion = randi_range(4,6)
					#var letra = Utils.random_string(characters,1)
					#posiciones_errores.erase(error_posicion)
					#var num := randi_range(0, 9 - 1)
					#if patente[error_posicion] == str(num):
						#num += 1
					#var patente_error = patente.substr(0, error_posicion) + patente.substr(error_posicion + 1)
					#label3d.text = patente_error.insert(error_posicion,str(letra))
					#patente = label3d.text
					#print("error de letra: ", letra, " posicion: ", error_posicion)
func generate_VTV_auto(probabilidad):
	var VTV = auto_data["vtv"]
	if Utils.chance(probabilidad):
		#correcto
		###VTV.text = str(num_vtv)
		
		print("la vtv del auto es true")
	else:
		#fake
		var num := randi_range(1, 12 - 1)
		if num >= int(VTV.text):
			num += 1
		###VTV.text = str(num)
		auto_ilegal = true
		print("la vtv del auto es fake")
func generate_fecha_cedula(probabilidad, probabilidad_2026):
	var fecha_de_vencimiento = auto_data["nacimiento"]
	
	if Utils.chance(probabilidad):
		#correcto
		###label3d.text = fecha_de_vencimiento
		print("la fecha de la ... esta bien")
	else:
		auto_ilegal = true
		if Utils.chance(probabilidad_2026):
			#fake
			var probabilidad_dia = 50
			if Utils.chance(probabilidad_dia):
				#dia fake
				var dia
				var mes = fecha_hoy["mes"]
				dia = randi_range(1,fecha_hoy["dia"] - 1)
				var fecha_dia_mes_ = str(dia,"/",mes,"/2026")
				###label3d.text = fecha_dia_mes_
				print("la fecha de la  esta mal (dia mal)")
			else:
				#mes fake
				var mes = randi_range(1,fecha_hoy["mes"] - 1)
				var dia := Utils.dias_en_mes(mes)
				var fecha_dia_mes_ = str(dia,"/",mes,"/2026")
				###label3d.text = fecha_dia_mes_
				print("la fecha de la  esta mal (mes mal)")
		else:
			#fake
			var fecha_dia_mes_ = Utils.generar_fecha(12,25)
			###label3d.text = fecha_dia_mes_ + str(anio_)
			print("la fecha de la  esta mal")
			
	return fecha_de_vencimiento
func generate_numero_licencia(probabilidad):
	#random numero_licencia
	
	var numero_licencia = auto_data["N Licencia"]
	var posiciones_errores = [0,1,2,4,5,6,7]
	if Utils.chance(probabilidad):
		#correcto
		###numero_licencia.text = str(num)
		print("el numero de la licencia es verdadera")
	else:
		#fake
		auto_ilegal = true
		
		var dificultad_papel = randi_range(1,7)
		
		if dificultad_papel == 7:
			#numero totalmente distinta
			var num_fake = randi_range(10000000,99999999)
			print("el numero de la licencia es fake, Real:",auto_data["N Licencia"]," / Fake:",num_fake)
			###numero_licencia.text = str(num_fake)
		else:
			for i in range(dificultad_papel):
				#numeros especificos diferentes
				var error_posicion = posiciones_errores.pick_random()
				posiciones_errores.erase(error_posicion)
				var num_error = Utils.random_excluding(0,9,numero_licencia[error_posicion])
				numero_licencia = Utils.cambiar_char(numero_licencia,posiciones_errores,str(num_error))
				###numero_licencia.text = patente_error.insert(error_posicion,str(num_error))
			print("Error en la licencia, Real:", auto_data["N licencia"]," / Falsa:", numero_licencia)
			print("Cantidad de errores en patente:",dificultad_papel)
	
	return numero_licencia
func generate_nombre(probabilidad):
	var nombre = auto_data["nombre"]
	###pcsistema.pc_control.set_modelo(modelo_auto)
	if Utils.chance(probabilidad):
		#correcto
		var nombre_ = Nombres_lista.values()[nombre]
		###modelo_cedula.text = modelo_auto
		print("el nombre de la cedula es verdad")
	else:
		#fake
		if Utils.random_excluding(0, Nombres_lista.size() - 2, nombre):
			nombre += 1
		var nombre_ = Nombres_lista.values()[nombre]
		###modelo_cedula.text = modelo_auto
		auto_ilegal = true
		print("el nombre de la cedula es fake")
func generate_apellido(probabilidad):
	var apellido = auto_data["apellido"]
	###pcsistema.pc_control.set_modelo(modelo_auto)
	if Utils.chance(probabilidad):
		#correcto
		var apellido_ = apellidos_lista.values()[apellido]
		###modelo_cedula.text = modelo_auto
		print("el apellido de la cedula es verdad")
	else:
		#fake
		if Utils.random_excluding(0, apellidos_lista.size() - 2, apellido):
			apellido += 1
		var apellido_ = Nombres_lista.values()[apellido]
		###modelo_cedula.text = modelo_auto
		auto_ilegal = true
		print("el apellido de la cedula es fake")
func generate_fecha_nacimiento(probabilidad, probabilidad_papeles_16):
	var nacimiento = auto_data["nacimiento"]
	
	if Utils.chance(probabilidad):
		#correcto
		###fecha_nacimiento_licencia.text = nacimiento
		print("la fecha de nacimiento esta bien")
	else:
		auto_ilegal = true
		if Utils.chance(probabilidad_papeles_16):
			#vas a tener que pedir papeles de los 16
			var probabilidad_dia = 50
			if Utils.chance(probabilidad_dia):
				#dia fake
				var dia
				var mes = nacimiento["mes"]
				dia = randi_range(1,nacimiento["dia"] - 1)
				var anio = randi_range(2009,2010)
				var fecha_dia_mes_ = str(dia,"/",mes,"/",anio)
				###label3d.text = fecha_dia_mes_
				print("la fecha de la  esta mal (dia mal)")
			else:
				#mes fake
				var mes = randi_range(1,nacimiento["mes"] - 1)
				var dia := Utils.dias_en_mes(mes)
				var anio = randi_range(2009,2010)
				var fecha_dia_mes_ = str(dia,"/",mes,"/",anio)
				###label3d.text = fecha_dia_mes_
				print("la fecha de la  esta mal (mes mal)")
		else:
			#fake
			nacimiento = Utils.generar_fecha(2011,2025)
			###fecha_nacimiento_licencia.text = fecha_dia_mes + str(anio)
			print("la fecha de nacimiento esta mal")

func generate_color_papel(probabilidad):
	#random color
	var color_info = auto_data["color_info"]
	var color = color_info["num_color"]
	
	if Utils.chance(probabilidad):
		#correcto
			
		###color_papel.text = str(colors.keys()[num_color])
		print("el color del papel es true")
	else:
		#fake
		auto_ilegal = true
		var num = Utils.random_excluding(0,colors.size() - 1,color)
		###color_papel.text = str(colors.keys()[num])
		print("el color del papel es falso")


func _generate_documentos() -> Dictionary:
	auto_data = AutoGenerator._auto_data
	var data = {}
	
	# BASE
	var color = generate_color_papel(Config["Probabilidad_color"])
	var vtv = generate_VTV_auto(Config["Probabilidad_vtv"])
	
	# CEDULA
	var fecha_cedula = generate_fecha_cedula(Config["Probabilidad_fecha_cedula"],Config["Probabilidad_fecha_cedula_2026"])
	var modelo_cedula = generate_modelo_cedula(Config["Probabilidad_modelo_cedula"])
	var patente_cedula = generate_papel_patente(Config["Probabilidad_patente_cedula"])
	
	# LICENCIA
	var nombre_licencia = generate_nombre(Config["Probabilidad_nombre_licencia"])
	var apellido_licencia = generate_apellido(Config["Probabilidad_apellido_licencia"])
	var numero_licencia = generate_numero_licencia(Config["Probabilidad_numero_licencia"])
	var nacimiento_licencia = generate_fecha_nacimiento(Config["Probabilidad_nacimineto_licencia"],Config["Probabilidad_nacimiento_16"])
	var fecha_licencia = generate_fecha_cedula(Config["Probabilidad_vencimiento_licencia"],Config["Probabilidad_fecha_licencia_2026"])
	
	# RESULTADO
	data = {
		"color": color,
		"vtv": vtv,
		"fecha_cedula": fecha_cedula,
		"modelo_cedula": modelo_cedula,
		"patente_cedula": patente_cedula,
		"nombre_licencia": nombre_licencia,
		"apellido_licencia": apellido_licencia,
		"numero_licencia": numero_licencia,
		"nacimiento_licencia": nacimiento_licencia,
		"fecha_licencia": fecha_licencia,
	}
	return data
