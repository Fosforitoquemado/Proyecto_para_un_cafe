extends Node

#daymanger
@onready var day_manager: Node = $"../DayManager"
var dia_hoy
#elementos auto
var config:GameConfig
var autos:AutoArrayResource
var tiposdeautos:tiposdeautosresources
var nombres:Nombresresources
var apellidos:Apellidosresources
var colores:ColoresResource
var objetosbaullegales:ObjetoArrayResource
var objetosbaulilegales:ObjetoArrayResource

var auto_data: Dictionary
var auto_ilegal: bool = false

var ilegalidades: int = 0
var errores: Array = []

var score_auto: float = 200.0

func _ready() -> void:
	dia_hoy = day_manager.get_day()
	config = dia_hoy.config
	autos = dia_hoy.autos_permitidos
	tiposdeautos = dia_hoy.tiposdeautos
	nombres = dia_hoy.nombres
	apellidos = dia_hoy.apellidos
	colores = dia_hoy.colores
	objetosbaullegales = dia_hoy.objetosbaullegales
	objetosbaulilegales = dia_hoy.objetosbaulilegales

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
		auto_ilegal = true
		ilegalidades += 1
		score_auto += 100.0
		errores.append(str("Modelo de la cedula es fake❌: ",modelo_))
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
		auto_ilegal = true
		ilegalidades += 1
		score_auto += 100.0
		var dificultad_papel = randi_range(1,7)
		errores.append(str("cantidad de errores: ",dificultad_papel))
		print("cantidad de errores: ",dificultad_papel)
			
		if dificultad_papel == 7:
			#patente total mente distinta
			var num_patente1 = randi_range(0,9)
			var num_patente2 = randi_range(0,9)
			var num_patente3 =  randi_range(0,9)
			
			var letras = Utils.random_string(3)
			patente = str(num_patente1,num_patente2,num_patente3," ",letras)
			errores.append(str("Patente del documento es fake❌: ",patente))
			print("Patente del documento es fake❌: ",patente)
			return patente
		else:
			score_auto += 300.0 / dificultad_papel
			patente = Utils.romper_patente(patente,dificultad_papel)
			errores.append(str("Patente del documento es fake❌: ",patente))
			print("Patente del documento es fake❌: ",patente)
			return patente
func generate_patente_faltante(probabilidad):
	#random patente
	var patente_faltante
	if Utils.chance(probabilidad):
		patente_faltante = "ninguna"
		print("No falta ninguna patente✅🎫")
	else:
		auto_ilegal = true
		ilegalidades += 1
		score_auto += 100.0
		
		if Utils.chance(50):
			patente_faltante = "atras"
			errores.append("Falta la patente trasera❌")
			print("Falta la patente trasera")
		else:
			patente_faltante = "adelante"
			errores.append("Falta la patente trasera❌")
			print("Falta la patente trasera")
	return patente_faltante
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
		auto_ilegal = true
		ilegalidades += 1
		score_auto += 100.0
		errores.append(str("Vtv del auto es fake❌: ", num))
		print("Vtv del auto es fake❌: ", num)
		return str(num)
func generate_fecha_documento(probabilidad, probabilidad_2026,fecha_de_vencimiento, fecha_hoy, documento):
	
	if Utils.chance(probabilidad):
		#correcto
		print("Fecha de ",documento," es verdadera✅: ",fecha_de_vencimiento)
		return fecha_de_vencimiento
	else:
		auto_ilegal = true
		ilegalidades += 1
		score_auto += 100.0
		if Utils.chance(probabilidad_2026):
			#fake
			score_auto += 100.0
			var probabilidad_dia = 50
			if Utils.chance(probabilidad_dia):
				#dia fake
				var dia
				var mes = fecha_hoy["mes"]
				dia = randi_range(1,fecha_hoy["dia"] - 1)
				var fecha_dia_mes_ = str(dia,"/",mes,"/2026")
				errores.append(str("Fecha de ",documento," es fake (dia mal)❌: ",fecha_dia_mes_))
				print("Fecha de ",documento," es fake (dia mal)❌: ",fecha_dia_mes_)
				return fecha_dia_mes_
			else:
				#mes fake
				var mes = randi_range(1,fecha_hoy["mes"] - 1)
				var dia := Utils.dias_en_mes(mes)
				var fecha_dia_mes_ = str(dia,"/",mes,"/2026")
				errores.append(str("Fecha de ",documento," es fake (mes mal)❌: ", fecha_dia_mes_))
				print("Fecha de ",documento," es fake (mes mal)❌: ", fecha_dia_mes_)
				return fecha_dia_mes_
		else:
			#fake
			var fecha_dia_mes_ = Utils.generar_fecha(2012,2025)
			errores.append(str("Fecha de ",documento," es fake❌: ",fecha_dia_mes_))
			print("Fecha de ",documento," es fake❌: ",fecha_dia_mes_)
			return fecha_dia_mes_
func generate_numero_licencia(probabilidad):
	var numero_licencia = auto_data["numero_licencia"]
	var posiciones_errores = [0,1,2,3,4,5,6,7]
	if Utils.chance(probabilidad):
		# correcto
		print("Numero de licencia es verdadera✅: ",numero_licencia)
		return numero_licencia
	else:
		# fake
		auto_ilegal = true
		ilegalidades += 1
		score_auto += 100.0
		var dificultad_papel = randi_range(1,7)
		if dificultad_papel == 7:
			# numero totalmente distinto
			var num_fake = str(randi_range(10000000,99999999))
			errores.append(str("Numero de licencia es fake❌: ",num_fake))
			print("Numero de licencia es fake❌: ",num_fake)
			return num_fake
		else:
			score_auto += 300.0 / dificultad_papel
			for i in range(dificultad_papel):
				# posición diferente
				var error_posicion = posiciones_errores.pick_random()
				posiciones_errores.erase(error_posicion)
				var num_error = Utils.random_excluding(0,9,int(numero_licencia[error_posicion]))
				numero_licencia = Utils.cambiar_char(numero_licencia,error_posicion,str(num_error))
			errores.append(str("Numero de la licencia es fake❌, Real:", auto_data["numero_licencia"]," / Falsa:", numero_licencia))
			print("Numero de la licencia es fake❌, Real:", auto_data["numero_licencia"]," / Falsa:", numero_licencia)
			print("Cantidad de errores en N licencia:",dificultad_papel)
			return numero_licencia
func generate_numero_id_seguro(probabilidad):
	var id_seguro = auto_data["id_seguro"]
	var posiciones_errores = [0,1,2,4,5,6,]
	if Utils.chance(probabilidad):
		# correcto
		print("Numero de id del seguro es verdadera✅: ",id_seguro)
		return id_seguro
	else:
		# fake
		auto_ilegal = true
		ilegalidades += 1
		score_auto += 100.0
		var dificultad_papel = randi_range(1,6)
		if dificultad_papel == 6:
			# numero totalmente distinto
			var num_fake = str(randi_range(100,999),"-",randi_range(100,999))
			errores.append(str("Numero de id del seguro es fake❌: ",num_fake))
			print("Numero de id del seguro es fake❌: ",num_fake)
			return num_fake
		else:
			score_auto += 300.0 / dificultad_papel
			for i in range(dificultad_papel):
				# posición diferente
				var error_posicion = posiciones_errores.pick_random()
				posiciones_errores.erase(error_posicion)
				var num_error = Utils.random_excluding(0,9,int(id_seguro[error_posicion]))
				id_seguro = Utils.cambiar_char(id_seguro,error_posicion,str(num_error))
			errores.append(str("Numero de el id del seguro es fake❌, Real:", auto_data["id_seguro"]," / Falsa:", id_seguro))
			print("Numero de el id del seguro es fake❌, Real:", auto_data["id_seguro"]," / Falsa:", id_seguro)
			print("Cantidad de errores en id seguro:",dificultad_papel)
			return id_seguro
func generate_nombre(probabilidad, documento):
	var nombre = auto_data["nombre_info"]["nombre_num"]
	if Utils.chance(probabilidad):
		#correcto
		var nombre_ = nombres.array[nombre]
		print("Nombre en ",documento," es verdadera✅: ",nombre_)
		return nombre_
	else:
		#fake
		var fake_nombre = Utils.random_excluding(0,nombres.array.size() - 1,nombre)
		auto_ilegal = true
		ilegalidades += 1
		score_auto += 100.0
		errores.append(str("Nombre de la cedula es fake❌: ",nombres.array[fake_nombre]))
		print("Nombre en ",documento," es fake❌: ",nombres.array[fake_nombre])
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
		auto_ilegal = true
		ilegalidades += 1
		score_auto += 100.0
		errores.append(str("Apellido de la cedula es fake❌: ",apellido_))
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
		auto_ilegal = true
		ilegalidades += 1
		score_auto += 100.0
		if Utils.chance(probabilidad_papeles_16):
			#vas a tener que pedir papeles de los 16
			var probabilidad_dia = 50
			score_auto += 100.0
			if Utils.chance(probabilidad_dia):
				#dia fake
				var dia
				var mes = nacimiento["mes"]
				dia = randi_range(1,nacimiento["dia"] - 1)
				var anio = randi_range(2009,2010)
				var fecha_dia_mes_ = str(dia,"/",mes,"/",anio)
				errores.append(str("Fecha de nacimiento es fake (dia mal)❌: ",fecha_dia_mes_))
				print("Fecha de nacimiento es fake (dia mal)❌: ",fecha_dia_mes_)
				return fecha_dia_mes_
			else:
				#mes fake
				var mes = randi_range(1,nacimiento["mes"] - 1)
				var dia := Utils.dias_en_mes(mes)
				var anio = randi_range(2009,2010)
				var fecha_dia_mes_ = str(dia,"/",mes,"/",anio)
				errores.append(str("Fecha de nacimiento es fake (mes mal)❌: ",fecha_dia_mes_))
				print("Fecha de nacimiento es fake (mes mal)❌: ",fecha_dia_mes_)
				return fecha_dia_mes_
		else:
			#fake
			nacimiento = Utils.generar_fecha(2011,2025)
			errores.append(str("Fecha de nacimiento es fake❌: ", nacimiento))
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
		#auto_ilegal = true
		var num = Utils.random_excluding(0,colores.dictionary.size() - 1,color)
		#print("Color del papel es fake❌")
		return num
func generate_objetos_baul(probabilidad, probabilidad_legal):
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
			ilegalidades += 1
			score_auto += 100.0
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
		var objeto_max_rotacion = objeto_random.max_rotacion
		var objeto_min_rotacion = objeto_random.min_rotacion
		var objeto_score = objeto_random.score
		# Actualizar estado
		if objeto_tamanio == "grande":
			hay_objeto_grande = true
		elif objeto_tamanio == "mediano":
			cantidad_medianos += 1
		# Debug
		if legal:
			print("Objeto ", i + 1, " legal📦✅: ", objeto_nombre)
		else:
			score_auto += objeto_score
			errores.append(str("El objeto ", i + 1, " es ilegal📦❌: ", objeto_nombre))
			print("Objeto ", i + 1, " ilegal📦❌: ", objeto_nombre)
		# Guardar
		objetos.append({
			"objeto": objeto_escena,
			"tamanio": objeto_tamanio,
			"nombre": objeto_nombre,
			"legal": legal,
			"max_rotacion": objeto_max_rotacion,
			"min_rotacion": objeto_min_rotacion
		})
		# Si salió grande → terminar
		if hay_objeto_grande:
			break
	return {
		"cantidad": objetos.size(),
		"objetos": objetos
	}
func generate_alcholemia(probabilidad):
	var alcholemia = 0.0
	if Utils.chance(probabilidad):
		#correcto
		print("el grado de alcholemia es 0✅: ",alcholemia)
		return str(alcholemia)
	else:
		#fake
		
		var num := randf_range(0.1,20.0)
		num = snapped(num, 0.1)
		auto_ilegal = true
		ilegalidades += 1
		score_auto += 100.0
		errores.append(str("el porcentaje de alcohol en sangre es mayor a 0❌: ", num))
		print("el porcentaje de alcohol en sangre es mayor a 0❌: ", num)
		return str(num)
func generate_tipo_permiso(probabilidad):
	var tipo_vehiculo = auto_data["modelo_info"]["num_tipo_vehiculo"]
	var num_tipo = tipo_vehiculo
	if Utils.chance(probabilidad):
		#correcto
		tipo_vehiculo = tiposdeautos.array[num_tipo]
		print("El tipo del auto es correcto✅: ",tipo_vehiculo)
		return tipo_vehiculo
	else:
		#fake
		var fake_tipo_num = Utils.random_excluding(0,tiposdeautos.array.size() - 1,num_tipo)
		var tipo = tiposdeautos.array[fake_tipo_num]
		auto_ilegal = true
		ilegalidades += 1
		score_auto += 100.0
		errores.append(str("El tipo del auto es incorrecto❌, es: ",tipo,"🚗 era: ",tiposdeautos.array[tipo_vehiculo],"🚗"))
		print("El tipo del auto es incorrecto❌, es: ",tipo,"🚗 era: ",tiposdeautos.array[tipo_vehiculo],"🚗")
		return tipo

func _generate_documentos() -> Dictionary:
	auto_data = AutoGenerator._auto_data
	auto_ilegal = false
	ilegalidades = 0
	errores = []
	score_auto = 200.0
	var daymanager = get_tree().get_first_node_in_group("DayManager")
	var day = daymanager.get_day()
	var fecha_hoy = day.fecha_hoy
	var data = {}
	
	# BASE
	var color = generate_color_papel(config.probabilidad_color)
	
	#patentes faltantes
	if "patente_faltantes" in day.documentos_habilitados:
		var patente_faltante = generate_patente_faltante(config.probabilidad_patente_faltante)
		var data_patente = {
			"patente_faltante": patente_faltante
		}
		data.merge(data_patente)
	#VTV
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
		var fecha_cedula = generate_fecha_documento(config.probabilidad_fecha_cedula,config.probabilidad_fecha_cedula_2026,auto_data["fecha_cedula"],fecha_hoy,"cedula")
		var data_cedula = {
		"patente_cedula": patente_cedula,
		"modelo_cedula": modelo_cedula,
		"fecha_cedula": fecha_cedula,
		}
		data.merge(data_cedula)
	
	# LICENCIA
	if "licencia" in day.documentos_habilitados:
		var nombre_licencia = generate_nombre(config.probabilidad_nombre_licencia,"licencia")
		var apellido_licencia = generate_apellido(config.probabilidad_apellido_licencia)
		var numero_licencia = generate_numero_licencia(config.probabilidad_numero_licencia)
		var nacimiento_licencia = generate_fecha_nacimiento(config.probabilidad_nacimineto_licencia,config.probabilidad_nacimiento_licencia_16)
		var fecha_licencia = generate_fecha_documento(config.probabilidad_fecha_licencia,config.probabilidad_fecha_licencia_2026,auto_data["fecha_licencia"],fecha_hoy,"licencia")
		var data_licencia = {
		"nombre_licencia": nombre_licencia,
		"apellido_licencia": apellido_licencia,
		"numero_licencia": numero_licencia,
		"nacimiento_licencia": nacimiento_licencia,
		"fecha_licencia": fecha_licencia,
		}
		data.merge(data_licencia)
	
	# SEGURO
	if "seguro" in day.documentos_habilitados:
		var asegurado_seguro = generate_nombre(config.probabilidad_nombre_seguro,"seguro")
		var id_seguro = generate_numero_id_seguro(config.probabilidad_id_seguro)
		var fecha_seguro = generate_fecha_documento(config.probabilidad_fecha_seguro,config.probabilidad_fecha_seguro_2026,auto_data["fecha_seguro"],fecha_hoy,"seguro")
		var data_seguro = {
		"asegurado_seguro": asegurado_seguro,
		"id_seguro": id_seguro,
		"fecha_seguro": fecha_seguro,
		}
		data.merge(data_seguro)
	
	#alcoholemia
	if "alcholemia" in day.documentos_habilitados:
		var alcholemia = generate_alcholemia(config.probabilidad_alcholemia)
		var data_alcholemia = {
		"alcholemia": alcholemia,
		}
		data.merge(data_alcholemia)
	
	#objetos del baul
	if "objetos_baul" in day.documentos_habilitados:
		var objeto_info = generate_objetos_baul(config.probabilidad_objeto_baul,config.probabilidad_objeto_baul_legal)
		var data_baul = {
		"objeto_info": objeto_info
		}
		data.merge(data_baul)
	
	#permiso por tipo de vehiculo
	if "permiso" in day.documentos_habilitados:
		var tipo_vehiculo_permiso = generate_tipo_permiso(config.probabilidad_tipo_vehiculo)
		var fecha_permiso = generate_fecha_documento(config.probabilidad_fecha_permiso,config.probabilidad_fecha_permiso_2026,auto_data["fecha_permiso"],fecha_hoy,"permiso")
		var data_permiso = {
		"tipo_vehiculo_permiso": tipo_vehiculo_permiso,
		"fecha_permiso": fecha_permiso
		}
		data.merge(data_permiso)
	
	#fecha hoy en string
	var fecha_hoy_string = str(fecha_hoy["dia"],"/",fecha_hoy["mes"],"/",fecha_hoy["anio"])
	
	# RESULTADO
	var data_extra = {
		"color": color,
		"fecha_hoy": fecha_hoy_string,
		"ilegalidades": ilegalidades,
		"errores": errores,
		"auto_ilegal": auto_ilegal,
		"score_auto": score_auto
	}
	data.merge(data_extra)
	auto_data = data
	print("DOCUMENTOS GENERADOS")
	if auto_ilegal:
		print("EL AUTO ES ILEGAL?: ILEGAL ❌🚗")
	else:
		print("EL AUTO ES ILEGAL?: LEGAL ✅🚗")
	print("ILEGALIDADES❌ ",ilegalidades)
	print("SCORE_AUTO🎫 " , score_auto)
	#print(data)
	return data
