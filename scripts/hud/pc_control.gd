extends Control

@onready var PCSISTEM:PCStatic

@onready var day_manager: Node = $"../../../DayManager"

@onready var cursor: AnimatedSprite2D = $Cursor
#fecha pc
@onready var fecha: Label = $Marco_Fecha/Fecha

@export var vtv: Label

@export var apagado: TextureRect
@export var cargando: TextureRect
@export var cargando_base_de_datos: TextureRect

@export var errores_auto_control: Control
@onready var exclamacion: MeshInstance3D = $"../../exclamacion"
@export var errores_label:PackedScene

#labels base de datos cedula
@export var dominio: Label 
@export var modelo: Label
@export var vence: Label

#labels base de datos licencia
@export var numero_licencia: Label
@export var nombre_licencia: Label
@export var apellido_licencia: Label
@export var fecha_de_nacimiento_licencia: Label
@export var fecha_de_vencimiento_licencia: Label

#labels seguro
@export var nombre_seguro: Label
@export var id_seguro: Label
@export var fecha_seguro: Label

#labels permiso
@export var tipo_vehiculo_permiso: Label
@export var fecha_permiso: Label

@export var basedatos_img: PanelContainer

var basededatos_active = false

@export var panel_windows:Array[DraggablePanelContainer]

var tiempo_de_carga

var pc_mouse_pos:Vector2 = Vector2.ZERO

func _ready() -> void:
	var dia = day_manager.get_day()
	
	tiempo_de_carga = dia.config["tiempo_de_carga"]
	apagado.visible = true
	cargando.visible = true
	errores_auto_control.visible = false
	basedatos_img.visible = false

func update_cursor_pos():
	cursor.position = pc_mouse_pos

#fecha PC

func set_fecha(func_fecha):
	fecha.text = func_fecha

#VTV

func set_vtv(func_VTV):
	vtv.text = func_VTV
#cedula

func set_dominio_cedula(func_dominio):
	dominio.text = func_dominio
func set_modelo_cedula(func_modelo):
	modelo.text = func_modelo
func set_vencimiento_cedula(func_vence):
	vence.text = func_vence

#licencia

func set_numero_licencia(func_numero):
	numero_licencia.text = func_numero
func set_nombre_licencia(func_nombre):
	nombre_licencia.text = func_nombre
func set_apellido_licencia(func_apellido):
	apellido_licencia.text = func_apellido
func set_fecha_nacimiento(func_fecha):
	fecha_de_nacimiento_licencia.text = func_fecha
func set_fecha_vencimiento(func_fecha):
	fecha_de_vencimiento_licencia.text = func_fecha

#seguro
func set_nombre_seguro(func_nombre):
	nombre_seguro.text = func_nombre
func set_id_seguro(func_id):
	id_seguro.text = func_id
func set_fecha_seguro(func_fecha):
	fecha_seguro.text = func_fecha

#permiso
func set_permiso_tipo_vehiculo(func_tipo):
	tipo_vehiculo_permiso.text = func_tipo
func set_fecha_permiso(func_fecha):
	fecha_permiso.text = func_fecha

func apagar_cargando():
	await get_tree().create_timer(tiempo_de_carga,false).timeout
	cargando.visible = false

func reset_pc():
	cargando.visible = true
	basedatos_img.visible = false
	basededatos_active = false
	cargando_base_de_datos.visible = true

func borrar_errores():
	exclamacion.visible = false
	errores_auto_control.visible = false
	var vbox = errores_auto_control.find_child("VBoxContainer")
	if vbox.get_children() != null:
		for i in vbox.get_children():
			i.queue_free()

func agregar_errores(errores):
	exclamacion.visible = true
	errores_auto_control.visible = true
	for i in errores.size():
		var errores_labels = errores_label.instantiate()
		var vbox = errores_auto_control.find_child("VBoxContainer")
		vbox.add_child(errores_labels)
		errores_labels.text = errores[i]
	
func _on_base_datos_pressed() -> void:
	if basededatos_active == true:
		basedatos_img.visible = false
		basededatos_active = false
		cargando_base_de_datos.visible = true
	else:
		basedatos_img.visible = true
		await get_tree().create_timer(tiempo_de_carga,false).timeout
		if PCSISTEM.is_using == false:
			cargando_base_de_datos.visible = false
			basededatos_active = true
	pass # Replace with function body.

func _on_exit_pressed() -> void:
	PCSISTEM.exit()
	reset_pc()
	pass # Replace with function body.

func _on_cerrar_errores_pressed() -> void:
	exclamacion.visible = false
	errores_auto_control.visible = false
	pass # Replace with function body.
