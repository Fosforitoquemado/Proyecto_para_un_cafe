extends Node


#elementos auto
@export var config:GameConfig = preload("res://recursos/dificultad/easy.tres")
@export var autos:AutoArrayResource = preload("res://recursos/ArrayAutos/TODOS.tres")
@export var nombres:Nombresresources = preload("res://recursos/nombres/nombres.tres")
@export var apellidos:Apellidosresources = preload("res://recursos/apellidos/apellidos.tres")
@export var colores:ColoresResource = preload("res://recursos/colores/colores.tres")
@export var objetosbaullegales:ObjetoArrayResource = preload("res://recursos/objetosbaularray/legales.tres")
@export var objetosbaulilegales:ObjetoArrayResource = preload("res://recursos/objetosbaularray/ilegales.tres")

var auto_data: Dictionary
var auto_ilegal: bool = false

func generate_modelo_cedula(probabilidad):
	var auto = auto_data["modelo_info"]
	var num_auto = auto["num_auto"]
	if Utils.chance(probabilidad):
		#correcto
		var modelo_ = autos.array[num_auto].nombre
		print("Modelo de la cedula es verdadera✅: ",modelo_)
		return modelo_
	else:
		#fake
		var fake_num_auto = Utils.random_excluding(0,autos.array.size() - 1, num_auto)
		var modelo_ = autos.array[fake_num_auto].nombre
		print("AUTO_ILEGAL modelo = TRUE")
		auto_ilegal = true
		print("Modelo de la cedula es fake❌: ",modelo_)
		return modelo_
func generate_papel_patente(probabilidad):
	var patente = auto_data["patente"]
	if Utils.chance(probabilidad):
		#correcto
		print("Patente del documento es verdadera✅: ", patente)
		return patente
	else:
		#fake
		print("AUTO_ILEGAL patente = TRUE")
		auto_ilegal = true
		var dificultad_papel = randi_range(1,7)
		print("cantidad de errores: ",dificultad_papel)
			
		if dificultad_papel == 7:
			#patente total mente distinta
			var num_patente1 = randi_range(0,9)
			var num_patente2 = randi_range(0,9)
			var num_patente3 =  randi_range(0,9)
			
			var letras = Utils.random_string(3)
			patente = str(num_patente1,num_patente2,num_patente3," ",letras)
			print("Patente del documento es fake❌: ",patente)
			return patente
		else:
			patente = Utils.romper_patente(patente,dificultad_papel)
			print("Patente del documento es fake❌: ",patente)
			return patente
func generate_VTV_auto(probabilidad):
	var VTV = auto_data["vtv_info"]["vtv"]
	if Utils.chance(probabilidad):
		#correcto
		print("Vtv del auto es verdadera✅: ",VTV)
		return str(VTV)
	else:
		#fake
		var num := randi_range(1, 12 - 1)
		if num >= VTV:
			num += 1
		print("AUTO_ILEGAL vtv = TRUE")
		auto_ilegal = true
		print("Vtv del auto es fake❌: ", num)
		return str(num)
func generate_fecha_documento(probabilidad, probabilidad_2026,fecha_de_vencimiento, fecha_hoy):
	
	if Utils.chance(probabilidad):
		#correcto
		print("Fecha del doucmento_x es verdadera✅: ",fecha_de_vencimiento)
		return fecha_de_vencimiento
	else:
		print("AUTO_ILEGAL fecha documento = TRUE")
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
				print("Fecha del documento_x es fake (dia mal)❌: ",fecha_dia_mes_)
				return fecha_dia_mes_
			else:
				#mes fake
				var mes = randi_range(1,fecha_hoy["mes"] - 1)
				var dia := Utils.dias_en_mes(mes)
				var fecha_dia_mes_ = str(dia,"/",mes,"/2026")
				print("Fecha del documento es fake (mes mal)❌: ", fecha_dia_mes_)
				return fecha_dia_mes_
		else:
			#fake
			var fecha_dia_mes_ = Utils.generar_fecha(2012,2025)
			print("Fecha del documento_x es fake❌: ",fecha_dia_mes_)
			return fecha_dia_mes_
func generate_numero_licencia(probabilidad):
	var numero_licencia = auto_data["numero_licencia"]
	var posiciones_errores = [0,1,2,4,5,6,7]
	if Utils.chance(probabilidad):
		# correcto
		print("Numero de licencia es verdadera✅: ",numero_licencia)
		return numero_licencia
	else:
		# fake
		print("AUTO_ILEGAL numero licencia = TRUE")
		auto_ilegal = true
		#var dificultad_papel = randi_range(1,7)
		var dificultad_papel = 6
		if dificultad_papel == 7:
			# numero totalmente distinto
			var num_fake = str(randi_range(10000000,99999999))
			print("Numero de licencia es fake❌: ",num_fake)
			return num_fake
		else:
			for i in range(dificultad_papel):
				# posición diferente
				var error_posicion = posiciones_errores.pick_random()
				posiciones_errores.erase(error_posicion)
				var num_error = Utils.random_excluding(0,9,int(numero_licencia[error_posicion]))
				numero_licencia = Utils.cambiar_char(numero_licencia,error_posicion,str(num_error))
			print("Numero de la licencia es fake❌, Real:", auto_data["numero_licencia"]," / Falsa:", numero_licencia)
			print("Cantidad de errores en N licencia:",dificultad_papel)
			return numero_licencia
func generate_nombre(probabilidad):
	var nombre = auto_data["nombre_info"]["nombre_num"]
	if Utils.chance(probabilidad):
		#correcto
		var nombre_ = nombres.array[nombre]
		print("Nombre de la cedula es verdadera✅: ",nombre_)
		return nombre_
	else:
		#fake
		var fake_nombre = Utils.random_excluding(0,nombres.array.size() - 1,nombre)
		print("AUTO_ILEGAL nombre = TRUE")
		auto_ilegal = true
		print("Nombre de la cedula es fake❌: ",nombres.array[fake_nombre])
		return nombres.array[fake_nombre]
func generate_apellido(probabilidad):
	var apellido = auto_data["apellido_info"]["apellido_num"]
	if Utils.chance(probabilidad):
		#correcto
		var apellido_ = apellidos.array[apellido]
		print("Apellido de la cedula es verdadera✅: ",apellido_)
		return apellido_
	else:
		#fake
		var fake_apellido_num = Utils.random_excluding(0, apellidos.array.size() - 1, apellido)
		var apellido_ = apellidos.array[fake_apellido_num]
		print("AUTO_ILEGAL apellido = TRUE")
		auto_ilegal = true
		print("Apellido de la cedula es fake❌: ",apellido_)
		return apellido_
func generate_fecha_nacimiento(probabilidad, probabilidad_papeles_16):
	var nacimiento = auto_data["nacimiento"]
	
	if Utils.chance(probabilidad):
		#correcto
		nacimiento = str(nacimiento["dia"],"/",nacimiento["mes"],"/",nacimiento["anio"])
		print("Fecha de nacimiento es verdadera✅: ",nacimiento)
		return nacimiento
	else:
		print("AUTO_ILEGAL nacimiento = TRUE")
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
				print("Fecha de nacimiento es fake (dia mal)❌: ",fecha_dia_mes_)
				return fecha_dia_mes_
			else:
				#mes fake
				var mes = randi_range(1,nacimiento["mes"] - 1)
				var dia := Utils.dias_en_mes(mes)
				var anio = randi_range(2009,2010)
				var fecha_dia_mes_ = str(dia,"/",mes,"/",anio)
				print("Fecha de nacimiento es fake (mes mal)❌: ",fecha_dia_mes_)
				return fecha_dia_mes_
		else:
			#fake
			nacimiento = Utils.generar_fecha(2011,2025)
			print("Fecha de nacimiento es fake❌: ", nacimiento)
			return nacimiento
func generate_color_papel(probabilidad):
	#random color
	var color_info = auto_data["color_info"]
	var color = color_info["num_color"]
	
	if Utils.chance(probabilidad):
		#correcto
		#print("olor del papel es verdadero✅")
		return color
	else:
		#fake
		print("AUTO_ILEGAL color = TRUE")
		#auto_ilegal = true
		var num = Utils.random_excluding(0,colores.dictionary.size() - 1,color)
		#print("Color del papel es fake❌")
		return num
func generate_objetos_baul(probabilidad,probabilidad_legal):
	var objeto = auto_data["objeto_baul_info"]
	var num_objeto = objeto["num_objeto"]
	var nombre
	#probabilidad de que no tenga un objeto
	if Utils.chance(probabilidad):
		#no se genera objeto
		
		print("No hay objeto en el baul📦")
		#print("El objeto del baul es verdadero✅: ",objeto_)
		return null
	else:
		var cantidaddeobjetos = randi_range(1,2)
		print("CANTIDAD OBJETOS",cantidaddeobjetos)
		#se genera objeto
		var objeto_1
		var tamanio_1
		var objeto_2
		var tamanio_2
		for i in range(cantidaddeobjetos):
			if Utils.chance(probabilidad_legal):
				var num_objeto_random = randi_range(0,objetosbaullegales.array.size() - 1)
				if i + 1 == 1:
					objeto_1 = objetosbaullegales.array[num_objeto_random].escena
					tamanio_1 = objetosbaullegales.array[num_objeto_random].tamanio
					nombre = objetosbaullegales.array[num_objeto_random].nombre
				else:
					objeto_2 = objetosbaullegales.array[num_objeto_random].escena
					tamanio_2 = objetosbaullegales.array[num_objeto_random].tamanio
					nombre = objetosbaullegales.array[num_objeto_random].nombre
				print("El objeto ",i," del baul es legal📦✅: ",nombre)
			else:
				var num_objeto_random = randi_range(0,objetosbaulilegales.array.size() - 1)
				if i + 1 == 1:
					objeto_1 = objetosbaulilegales.array[num_objeto_random].escena
					tamanio_1 = objetosbaulilegales.array[num_objeto_random].tamanio
					nombre = objetosbaulilegales.array[num_objeto_random].nombre
				elif i + 1 == 2:
					objeto_2 = objetosbaulilegales.array[num_objeto_random].escena
					tamanio_2 = objetosbaulilegales.array[num_objeto_random].tamanio
					nombre = objetosbaulilegales.array[num_objeto_random].nombre
				auto_ilegal = true
				print("AUTO_ILEGAL objeto = TRUE")
				print("El objeto ",i," del baul es ilegal📦❌: ",nombre)
		var objeto_info = {
			"objeto1": objeto_1,
			"tamanio1": tamanio_1,
			"objeto2": objeto_2,
			"tamanio2": tamanio_2,
			"cantidad": cantidaddeobjetos
		}
		return objeto_info
func generate_objetos_baul2(probabilidad, probabilidad_legal):
	# Probabilidad de NO generar objetos
	if Utils.chance(probabilidad):
		print("No hay objeto en el baul📦")
		return null
	var objetos = []
	# Estado del baúl
	var hay_objeto_grande = false
	var cantidad_medianos = 0
	# Máximo intento de generación
	var cantidad_intentos = randi_range(1, 2)
	for i in range(cantidad_intentos):
		var pool
		var legal = true
		# Elegir legal / ilegal
		if Utils.chance(probabilidad_legal):
			pool = objetosbaullegales.array
		else:
			pool = objetosbaulilegales.array
			legal = false
			auto_ilegal = true
		if pool.is_empty():
			continue
		# Filtrar según espacio disponible
		var pool_filtrada = []
		for obj in pool:
			# Si ya hay grande → no entra nada más
			if hay_objeto_grande:
				break
			# Si ya hay 2 medianos → no entra nada más
			if cantidad_medianos >= 2:
				break
			# Si ya hay medianos → bloquear grandes
			if cantidad_medianos > 0 and obj.tamanio == "grande":
				continue
			pool_filtrada.append(obj)
		# Si no quedó nada válido
		if pool_filtrada.is_empty():
			break
		# Elegir objeto random válido
		var objeto_random = pool_filtrada.pick_random()
		var objeto_escena = objeto_random.escena
		var objeto_tamanio = objeto_random.tamanio
		var objeto_nombre = objeto_random.nombre
		# Actualizar estado
		if objeto_tamanio == "grande":
			hay_objeto_grande = true
		elif objeto_tamanio == "mediano":
			cantidad_medianos += 1
		# Debug
		if legal:
			print("Objeto ", i + 1, " legal📦✅: ", objeto_nombre)
		else:
			print("AUTO_ILEGAL objeto = TRUE")
			print("Objeto ", i + 1, " ilegal📦❌: ", objeto_nombre)
		# Guardar
		objetos.append({
			"objeto": objeto_escena,
			"tamanio": objeto_tamanio,
			"nombre": objeto_nombre,
			"legal": legal
		})
		# Si salió grande → terminar
		if hay_objeto_grande:
			break
	return {
		"cantidad": objetos.size(),
		"objetos": objetos
	}

func _generate_documentos() -> Dictionary:
	auto_data = AutoGenerator._auto_data
	auto_ilegal = false
	var daymanager = get_tree().get_first_node_in_group("DayManager")
	var day = daymanager.get_day()
	var fecha_hoy = day.fecha_hoy
	var data = {}
	
	# BASE
	var color = generate_color_papel(config.probabilidad_color)
	
	if "vtv" in day.documentos_habilitados:
		var vtv = generate_VTV_auto(config.probabilidad_vtv)
		var data_vtv = {
			"vtv": vtv,
		}
		data.merge(data_vtv)
	
	# CEDULA
	if "cedula" in day.documentos_habilitados:
		var patente_cedula = generate_papel_patente(config.probabilidad_patente_cedula)
		var modelo_cedula = generate_modelo_cedula(config.probabilidad_modelo_cedula)
		var fecha_cedula = generate_fecha_documento(config.probabilidad_fecha_cedula,config.probabilidad_fecha_cedula_2026,auto_data["fecha_cedula"],fecha_hoy)
		var data_cedula = {
		"patente_cedula": patente_cedula,
		"modelo_cedula": modelo_cedula,
		"fecha_cedula": fecha_cedula,
		}
		data.merge(data_cedula)
	
	# LICENCIA
	if "licencia" in day.documentos_habilitados:
		var nombre_licencia = generate_nombre(config.probabilidad_nombre_licencia)
		var apellido_licencia = generate_apellido(config.probabilidad_apellido_licencia)
		var numero_licencia = generate_numero_licencia(config.probabilidad_numero_licencia)
		var nacimiento_licencia = generate_fecha_nacimiento(config.probabilidad_nacimineto_licencia,config.probabilidad_nacimiento_16)
		var fecha_licencia = generate_fecha_documento(config.probabilidad_fecha_licencia,config.probabilidad_fecha_licencia_2026,auto_data["fecha_licencia"],fecha_hoy)
		var data_licencia = {
		"nombre_licencia": nombre_licencia,
		"apellido_licencia": apellido_licencia,
		"numero_licencia": numero_licencia,
		"nacimiento_licencia": nacimiento_licencia,
		"fecha_licencia": fecha_licencia,
		}
		data.merge(data_licencia)
	
	if "objetos_baul" in day.documentos_habilitados:
		var objeto_info = generate_objetos_baul2(config.probabilidad_objeto_baul,config.probabilidad_objeto_baul_legal)
		var data_baul = {
		"objeto_info": objeto_info
		}
		data.merge(data_baul)
	
	var fecha_hoy_string = str(fecha_hoy["dia"],"/",fecha_hoy["mes"],"/",fecha_hoy["anio"])
	
	# RESULTADO
	var data_extra = {
		"color": color,
		"fecha_hoy": fecha_hoy_string,
	}
	data.merge(data_extra)
	print("DOCUMENTOS GENERADOS")
	if auto_ilegal:
		print("EL AUTO ES ILEGAL?: ILEGAL ❌🚗")
	else:
		print("EL AUTO ES ILEGAL?: LEGAL ✅🚗")
	#print(data)
	return data
