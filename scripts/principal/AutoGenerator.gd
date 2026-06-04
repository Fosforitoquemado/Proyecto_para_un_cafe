extends Node

#@export var autos:AutoArrayResource = preload("res://recursos/ArrayAutos/TODOS.tres")
#@export var nombres:Nombresresources = preload("res://recursos/nombres/nombres.tres")
#@export var apellidos:Apellidosresources = preload("res://recursos/apellidos/apellidos.tres")
@export var objetosbaul:ObjetoArrayResource = preload("res://recursos/objetosbaularray/todos.tres")
#@export var personajes:PersonajesArrayResource = preload("res://recursos/Arraypersonajes/TODOS.tres")
@export var dialogo_llegada:DialogosGlobalArray = preload("res://recursos/Dialogos/dialogos_llegadaarray/TODOS.tres")
@export var dialogo_ida_bien:DialogosGlobalArray = preload("res://recursos/Dialogos/dialogos_ida_bienarray/TODOS.tres")
@export var dialogo_ida_multa:DialogosGlobalArray = preload("res://recursos/Dialogos/dialogos_ida_multaarray/TODOS.tres")
@export var dialogo_ida_coima:DialogosGlobalArray = preload("res://recursos/Dialogos/dialogos_ida_coimaarray/TODOS.tres")

var autos:AutoArrayResource
var nombres:Nombresresources
var apellidos:Apellidosresources
#var objetosbaul:ObjetoArrayResource
var personajes:PersonajesArrayResource
#var dialogo_llegada:DialogosGlobalArray
#var dialogo_ida_bien:DialogosGlobalArray
#var dialogo_ida_multa:DialogosGlobalArray
#var dialogo_ida_coima:DialogosGlobalArray
var colores:ColoresResource

var _auto_data: Dictionary

func generate_modelo():
	var num_auto_random = randi_range(0,autos.array.size() - 1)
	var resource = autos.array[num_auto_random]
	var auto = resource.escena
	var nombre = resource.nombre
	var tipo_vehiculo = resource.tipo_vehiculo
	var num_tipo = resource.num_tipo_vehiculo
	var modelo_info = {
		"auto": auto,
		"num_auto": num_auto_random,
		"nombre":  nombre,
		"tipo_vehiculo": tipo_vehiculo,
		"num_tipo_vehiculo": num_tipo,
	}
	return modelo_info
func generate_color():
	var num_color = randi_range(0,colores.dictionary.size() - 1)
	var color = colores.dictionary.values()[num_color]
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
	
	var letras = Utils.random_string(3)
	var patente = str(num_patente1,num_patente2,num_patente3," ",letras)
	
	return patente
func generate_VTV() -> Dictionary:
	#le meti un parche en el documentosgenerator
	var vtv = randi_range(6,12)
	var vtv_string = str(vtv)
	var vtv_info = {
		"vtv": vtv,
		"vtv_string": vtv_string
	}
	return vtv_info
func generate_numero_licencia() -> String:
	#random numero_licencia
	var num = str(randi_range(10000000,99999999))
	return num
func generate_id_seguro() -> String:
	#random numero_id_seguro
	var num = str(randi_range(100,999),"-",randi_range(100,999))
	return num
func generate_nombre() -> Dictionary:
	var nombre_num = randi_range(0,nombres.array.size() - 1)
	var nombre = nombres.array[nombre_num]
	var nombre_info = {
		"nombre_num": nombre_num,
		"nombre": nombre
	}
	return nombre_info
func generate_apellido() -> Dictionary:
	var apellido_num = randi_range(0,apellidos.array.size() - 1)
	var apellido = apellidos.array[apellido_num]
	var apellido_info = {
		"apellido_num": apellido_num,
		"apellido": apellido
	}
	return apellido_info
func generate_fecha_nacimiento() -> Dictionary:
	var mes := randi_range(1, 12)
	var dia := Utils.dias_en_mes(mes)
	dia = randi_range(1, dia)
	var anio := randi_range(1945, 2008)
	var fecha_entera = str(dia,"/",mes,"/",anio)
	var nacimiento = {
		"dia": dia,
		"mes": mes,
		"anio": anio,
		"fecha_entera": fecha_entera
	}
	return nacimiento
func generate_fecha_vencimiento() -> String:
	var vencimiento = Utils.generar_fecha(2027,2030)
	return vencimiento
func generate_dinero_coima() -> float:
	var dinero_coima = randf_range(10,100)
	dinero_coima = snapped(dinero_coima, 0.01)
	return dinero_coima
func generate_objetos_baul():
	var num_objeto_random = randi_range(0,objetosbaul.array.size() - 1)
	var resource = objetosbaul.array[num_objeto_random]
	var objeto = resource.escena
	var nombre = resource.nombre
	var modelo_info = {
		"objeto": objeto,
		"num_objeto": num_objeto_random,
		"nombre":  nombre,
	}
	return modelo_info
func generate_personaje():
	var num_personaje_random = randi_range(0,personajes.array.size() - 1)
	var resource = personajes.array[num_personaje_random]
	var personaje = resource.escena
	var nombre = resource.nombre
	var modelo_info = {
		"personaje": personaje,
		"num_personaje": num_personaje_random,
		"nombre":  nombre,
	}
	return modelo_info
#Dialogos
func generate_dialogo_llegada():
	var num_dialogo_random = randi_range(0,dialogo_llegada.array.size() - 1)
	var resource = dialogo_llegada.array[num_dialogo_random]
	var dialogo_info = {
		"resource": resource,
		"num_dialogo": num_dialogo_random,
	}
	return dialogo_info
func generate_dialogo_ida_bien():
	var num_dialogo_random = randi_range(0,dialogo_ida_bien.array.size() - 1)
	var resource = dialogo_ida_bien.array[num_dialogo_random]
	var dialogo_info = {
		"resource": resource,
		"num_dialogo": num_dialogo_random,
	}
	return dialogo_info
func generate_dialogo_ida_multa():
	var num_dialogo_random = randi_range(0,dialogo_ida_multa.array.size() - 1)
	var resource = dialogo_ida_multa.array[num_dialogo_random]
	var dialogo_info = {
		"resource": resource,
		"num_dialogo": num_dialogo_random,
	}
	return dialogo_info
func generate_dialogo_ida_coima():
	var num_dialogo_random = randi_range(0,dialogo_ida_coima.array.size() - 1)
	var resource = dialogo_ida_coima.array[num_dialogo_random]
	var dialogo_info = {
		"resource": resource,
		"num_dialogo": num_dialogo_random,
	}
	return dialogo_info

func _generate_auto() -> Dictionary:
	var data = {}
	
	var day_manager = get_tree().get_first_node_in_group("DayManager")
	var dia = day_manager.get_day()
	autos = dia.autos_permitidos
	nombres = dia.nombres
	apellidos = dia.apellidos
	colores = dia.colores
	personajes = dia.personajes
	
	# BASE
	var personaje = generate_personaje()
	var dialogo_llegada_info = generate_dialogo_llegada()
	var dialogo_ida_bien_info = generate_dialogo_ida_bien()
	var dialogo_ida_multa_info = generate_dialogo_ida_multa()
	var dialogo_ida_coima_info = generate_dialogo_ida_coima()
	var patente = generate_patente()
	var color_info = generate_color()
	var modelo_info = generate_modelo()
	var vtv_info = generate_VTV()
	var nombre_info = generate_nombre()
	var apellido_info = generate_apellido()
	var licencia = generate_numero_licencia()
	var id_seguro = generate_id_seguro()
	var nacimiento = generate_fecha_nacimiento()
	var dinero_coima = generate_dinero_coima()
	var objeto_baul_info = generate_objetos_baul()
	
	# DOCUMENTOS
	var fecha_cedula = generate_fecha_vencimiento()
	var fecha_licencia = generate_fecha_vencimiento()
	var fecha_seguro = generate_fecha_vencimiento()
	var fecha_permiso = generate_fecha_vencimiento()
	
	# RESULTADO
	data = {
		"personaje_info": personaje,
		"dialogo_llegada_info": dialogo_llegada_info,
		"dialogo_ida_bien_info": dialogo_ida_bien_info,
		"dialogo_ida_multa_info": dialogo_ida_multa_info,
		"dialogo_ida_coima_info": dialogo_ida_coima_info,
		"patente": patente,
		"nombre_info": nombre_info,
		"apellido_info": apellido_info,
		"nacimiento": nacimiento,
		"color_info": color_info,
		"modelo_info": modelo_info,
		"vtv_info": vtv_info,
		"numero_licencia": licencia,
		"id_seguro": id_seguro,
		"fecha_cedula": fecha_cedula,
		"fecha_licencia": fecha_licencia,
		"fecha_seguro": fecha_seguro,
		"fecha_permiso": fecha_permiso,
		"dinero_coima": dinero_coima,
		"objeto_baul_info": objeto_baul_info
	}
	_auto_data = data
	#print(_auto_data)
	print("AUTO GENERADO🚗")
	return data
