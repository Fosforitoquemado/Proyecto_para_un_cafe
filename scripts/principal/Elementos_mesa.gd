extends Node3D

@onready var pcsistema: PCStatic = $"../PCSISTEMA"
@onready var pc_control: Control = $"../PCSISTEMA/SubViewport/PCControl"

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
	print(datos_documentos)
	#fecha pc
	pc_control.set_fecha(datos_documentos["fecha_hoy"])
	
	#elementos_auto
	GameManager.auto_dupe.find_child("mes_VTV").text = AutoGenerator._auto_data["vtv_info"]["vtv_string"]
	pc_control.set_vtv(AutoGenerator._auto_data["vtv_info"]["vtv_string"])
	GameManager.auto_dupe.find_child("patente_adelante").text = AutoGenerator._auto_data["patente"]
	GameManager.auto_dupe.find_child("patente_atras").text = AutoGenerator._auto_data["patente"]
	
	#cedula
	cedula.visible = true
	
	dominio_cedula.text = datos_documentos["patente_cedula"] #🎫🎫🎫
	pc_control.set_dominio(AutoGenerator._auto_data["patente"])
	modelo_cedula.text = datos_documentos["modelo_cedula"] #🎫🎫🎫
	pc_control.set_modelo(AutoGenerator._auto_data["modelo_info"]["nombre"])
	vencimiento_cedula.text = datos_documentos["fecha_cedula"] #🎫🎫🎫
	pc_control.set_vencimiento(AutoGenerator._auto_data["fecha_cedula"])
	
	#licencia
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
