extends Node3D

@onready var pcsistema: PCStatic = $"../PCSISTEMA"
@onready var pc_control: Control = $"../PCSISTEMA/SubViewport/PCControl"

@onready var day_manager: Node = $"../DayManager"

#cedula
@export var cedula: Sprite3D
@export var dominio_cedula: Label3D
@export var modelo_cedula: Label3D
@export var vencimiento_cedula: Label3D

#licencia
@export var licencia: Sprite3D
@export var numero_licencia: Label3D
@export var apellido_licencia: Label3D
@export var nombre_licencia: Label3D
@export var fecha_nacimiento_licencia: Label3D
@export var vencimiento_licencia: Label3D

var datos_documentos

func mostrar_datos():
	datos_documentos = DocumentosGenerator._generate_documentos()
	var day = day_manager.get_day()
	
	#fecha pc
	pc_control.set_fecha(datos_documentos["fecha_hoy"])
	
	#elementos_auto
	if "vtv" in day.documentos_habilitados:
		GameManager.auto_dupe.find_child("mes_VTV").text = datos_documentos["vtv"]
		pc_control.set_vtv(AutoGenerator._auto_data["vtv_info"]["vtv_string"])
		GameManager.auto_dupe.find_child("VTV").visible = true
	
	GameManager.auto_dupe.find_child("patente_adelante").text = AutoGenerator._auto_data["patente"]
	GameManager.auto_dupe.find_child("patente_adelante").visible = true
	GameManager.auto_dupe.find_child("patente_atras").text = AutoGenerator._auto_data["patente"]
	GameManager.auto_dupe.find_child("patente_atras").visible = true
	
	#if "objetos_baul" in day.documentos_habilitados and datos_documentos["objeto_info"] != null:
		#var ocupado = false
		#for i in range(datos_documentos["objeto_info"]["cantidad"]):
			#print(i)
			#var objeto_dupe = datos_documentos["objeto_info"][str("objeto",i + 1)].instantiate()
			#var objeto_tamanio = datos_documentos["objeto_info"][str("tamanio",i + 1)]
			##var nombre = objeto_tamanio["nombre"]
		#
			#GameManager.auto_dupe.add_child(objeto_dupe)
			#if objeto_tamanio == "grande":
				#objeto_dupe.position = GameManager.auto_dupe.find_child("nodo_baul_grande").position
			#elif objeto_tamanio == "mediano":
				#if ocupado == false:
					##if Utils.chance(50):
					#objeto_dupe.position = GameManager.auto_dupe.find_child("nodo_baul_mediano_izq").position
					#ocupado = true
				#else:
					#objeto_dupe.position = GameManager.auto_dupe.find_child("nodo_baul_mediano_der").position
	if "objetos_baul" in day.documentos_habilitados and datos_documentos["objeto_info"] != null:
		var ocupado = false
		for objeto_data in datos_documentos["objeto_info"]["objetos"]:
			var objeto_dupe = objeto_data["objeto"].instantiate()
			var objeto_tamanio = objeto_data["tamanio"]
			if objeto_tamanio == "grande":
				GameManager.auto_dupe.find_child("nodo_baul_grande").add_child(objeto_dupe)
				#objeto_dupe.position = GameManager.auto_dupe.find_child("nodo_baul_grande").position
			elif objeto_tamanio == "mediano":
				if ocupado == false:
					GameManager.auto_dupe.find_child("nodo_baul_mediano_izq").add_child(objeto_dupe)
					#objeto_dupe.position = GameManager.auto_dupe.find_child("nodo_baul_mediano_izq").position
					ocupado = true
				else:
					GameManager.auto_dupe.find_child("nodo_baul_mediano_der").add_child(objeto_dupe)
					#objeto_dupe.position = GameManager.auto_dupe.find_child("nodo_baul_mediano_der").position
	#cedula
	if "cedula" in day.documentos_habilitados:
		cedula.visible = true
	
		dominio_cedula.text = datos_documentos["patente_cedula"] #🎫🎫🎫
		pc_control.set_dominio(AutoGenerator._auto_data["patente"])
		modelo_cedula.text = datos_documentos["modelo_cedula"] #🎫🎫🎫
		pc_control.set_modelo(AutoGenerator._auto_data["modelo_info"]["nombre"])
		vencimiento_cedula.text = datos_documentos["fecha_cedula"] #🎫🎫🎫
		pc_control.set_vencimiento(AutoGenerator._auto_data["fecha_cedula"])
	
	#licencia
	if "licencia" in day.documentos_habilitados:
		licencia.visible = true
	
		numero_licencia.text = datos_documentos["numero_licencia"]#🎫🎫🎫
		pc_control.set_numero_licencia(AutoGenerator._auto_data["numero_licencia"])
		nombre_licencia.text = datos_documentos["nombre_licencia"]#🎫🎫🎫
		pc_control.set_nombre(AutoGenerator._auto_data["nombre_info"]["nombre"])
		apellido_licencia.text = datos_documentos["apellido_licencia"]#🎫🎫🎫
		pc_control.set_apellido(AutoGenerator._auto_data["apellido_info"]["apellido"])
		fecha_nacimiento_licencia.text = datos_documentos["nacimiento_licencia"]#🎫🎫🎫
		pc_control.set_fecha_nacimiento(AutoGenerator._auto_data["nacimiento"]["fecha_entera"])
		vencimiento_licencia.text = datos_documentos["fecha_licencia"]#🎫🎫🎫
		pc_control.set_fecha_vencimiento(AutoGenerator._auto_data["fecha_licencia"])
	
	print("FINAL MOSTRAR DATOS")
func datos_cedula():
	print("hola")
