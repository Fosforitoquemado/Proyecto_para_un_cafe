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
	GameManager.auto_dupe.find_child("mes_VTV").text = datos_documentos["vtv"]
	GameManager.auto_dupe.find_child("patente_adelante").text = AutoGenerator._auto_data["patente"]
	GameManager.auto_dupe.find_child("patente_atras").text = AutoGenerator._auto_data["patente"]
	
	#cedula
	cedula.visible = true
	
	dominio_cedula.text = datos_documentos["patente_cedula"] #🎫🎫🎫
	pc_control.set_dominio(datos_documentos["patente_cedula"])
	modelo_cedula.text = datos_documentos["modelo_cedula"] #🎫🎫🎫
	pc_control.set_modelo(datos_documentos["modelo_cedula"])
	vencimiento_cedula.text = datos_documentos["fecha_cedula"] #🎫🎫🎫
	pc_control.set_vencimiento(datos_documentos["fecha_cedula"])
	
	#licencia
	licencia.visible = true
	
	numero_licencia.text = datos_documentos["numero_licencia"]#🎫🎫🎫
	pc_control.set_numero_licencia(datos_documentos["numero_licencia"])
	nombre_licencia.text = datos_documentos["nombre_licencia"]#🎫🎫🎫
	pc_control.set_nombre(datos_documentos["nombre_licencia"])
	apellido_licencia.text = datos_documentos["apellido_licencia"]#🎫🎫🎫
	pc_control.set_apellido(datos_documentos["apellido_licencia"])
	fecha_nacimiento_licencia.text = datos_documentos["nacimiento_licencia"]#🎫🎫🎫
	pc_control.set_fecha_nacimiento(datos_documentos["nacimiento_licencia"])
	vencimiento_licencia.text = datos_documentos["fecha_licencia"]#🎫🎫🎫
	pc_control.set_fecha_vencimiento(datos_documentos["fecha_licencia"])
	
	print("FINAL MOSTRAR DATOS")
func datos_cedula():
	print("hola")
