extends Control

@onready var PCSISTEM:PCStatic

@onready var day_manager: Node = $"../../../DayManager"

@onready var cursor: AnimatedSprite2D = $Cursor

@onready var fecha: Label = $Marco_Fecha/Fecha
@onready var dominio: Label = $basedatos_img/Dominio_cedula
@onready var modelo: Label = $basedatos_img/Modelo_cedula
@onready var vence: Label = $basedatos_img/Vence
@onready var vtv: Label = $basedatos_img/VTV

@onready var apagado: TextureRect = $apagado
@onready var cargando: TextureRect = $cargando
@onready var cargando_base_de_datos: TextureRect = $basedatos_img/cargando

#labels base de datos licencia
@onready var numero_licencia: Label = $basedatos_img/numero_licencia
@onready var nombre_licencia: Label = $basedatos_img/nombre_licencia
@onready var apellido_licencia: Label = $basedatos_img/apellido_licencia
@onready var fecha_de_nacimiento_licencia: Label = $basedatos_img/Fecha_De_Nacimiento_licencia
@onready var fecha_de_vencimiento_licencia: Label = $basedatos_img/Fecha_De_Vencimiento_licencia

@onready var basedatos_img: TextureRect = $basedatos_img

var basededatos_active = false

var tiempo_de_carga

var pc_mouse_pos:Vector2 = Vector2.ZERO

func _ready() -> void:
	var dia = day_manager.get_day()
	
	tiempo_de_carga = dia.config["tiempo_de_carga"]

func update_cursor_pos():
	cursor.position = pc_mouse_pos

#fecha PC

func set_fecha(func_fecha):
	fecha.text = func_fecha

#VTV

func set_vtv(func_VTV):
	vtv.text = func_VTV
#cedula

func set_dominio(func_dominio):
	dominio.text = func_dominio
func set_modelo(func_modelo):
	modelo.text = func_modelo
func set_vencimiento(func_vence):
	vence.text = func_vence

#licencia

func set_numero_licencia(func_numero):
	numero_licencia.text = func_numero
func set_nombre(func_nombre):
	nombre_licencia.text = func_nombre
func set_apellido(func_apellido):
	apellido_licencia.text = func_apellido
func set_fecha_nacimiento(func_fecha):
	fecha_de_nacimiento_licencia.text = func_fecha
func set_fecha_vencimiento(func_fecha):
	fecha_de_vencimiento_licencia.text = func_fecha

func apagar_cargando():
	await get_tree().create_timer(tiempo_de_carga,false).timeout
	cargando.visible = false

func reset_pc():
	cargando.visible = true
	basedatos_img.visible = false
	basededatos_active = false
	cargando_base_de_datos.visible = true

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
	PCSISTEM.toggle_use()
	PCSISTEM.exit()
	reset_pc()
	pass # Replace with function body.
