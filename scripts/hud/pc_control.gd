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

#labels cedula
@export var dominio_cedula: Label 
@export var modelo_cedula: Label
@export var vence_cedula: Label

#labels licencia
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

@export var icono_vtv:TextureRect
@export var icono_cedula:TextureRect
@export var icono_licencia:TextureRect
@export var icono_seguro:TextureRect
@export var icono_permiso:TextureRect

var basededatos_active = false

@export var panel_windows:Array[DraggablePanelContainer]

var tiempo_de_carga

@onready var fsm: Node = $StateMachine
@export var libro_container:PanelContainer
@onready var libro_guia: AnimatedSprite2D = $PanelContainer_instrucciones/libro_guia


var busy: bool = false
var pag_number = 1
var min_pag_number = 1
var max_pag_number = 3

var pc_mouse_pos:Vector2 = Vector2.ZERO

func _ready() -> void:
	var dia = day_manager.get_day()
	
	tiempo_de_carga = dia.config["tiempo_de_carga"]
	icono_vtv.hide()
	icono_cedula.hide()
	icono_licencia.hide()
	icono_seguro.hide()
	icono_permiso.hide()
	if "vtv" in dia.documentos_habilitados:
		icono_vtv.show()
	if "cedula" in dia.documentos_habilitados:
		icono_cedula.show()
	if "licencia" in dia.documentos_habilitados:
		icono_licencia.show()
	if "seguro" in dia.documentos_habilitados:
		icono_seguro.show()
	if "permiso" in dia.documentos_habilitados:
		icono_permiso.show()
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
func set_cedula(func_dominio,func_modelo,func_vence):
	dominio_cedula.text = func_dominio
	modelo_cedula.text = func_modelo
	vence_cedula.text = func_vence

#licencia
func set_licencia(func_numero,func_nombre,func_apellido,func_fecha_nacimiento,func_fecha_vencimiento):
	numero_licencia.text = func_numero
	
	nombre_licencia.text = func_nombre
	
	apellido_licencia.text = func_apellido
	fecha_de_nacimiento_licencia.text = func_fecha_nacimiento
	fecha_de_vencimiento_licencia.text = func_fecha_vencimiento

#seguro
func set_seguro(func_nombre,func_id,func_fecha_vencimiento):
	nombre_seguro.text = func_nombre
	id_seguro.text = func_id
	fecha_seguro.text = func_fecha_vencimiento

#permiso
func set_permiso(func_tipo,func_fecha_vencimiento):
	tipo_vehiculo_permiso.text = func_tipo
	fecha_permiso.text = func_fecha_vencimiento

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

func ajustar_texto(label: Label):
	var font_size = 32
	label.label_settings.font_size = font_size

	while label.get_minimum_size().x > label.size.x and font_size > 8:
		font_size -= 1
		label.label_settings.font_size = font_size

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


func _on_button_flecha_derecha_pressed() -> void:
	if pag_number < max_pag_number and not busy:
		busy = true
		libro_container.find_child(str("pag", pag_number)).hide()
		pag_number += 1
			
		# Animación de pasar página hacia adelante
		libro_guia.play("default")
		
		await libro_guia.animation_finished
			
		# Cambiamos al estado de la nueva página
		fsm.change_to(str("pag", pag_number))
		busy = false
	pass # Replace with function body.


func _on_button_flecha_izquierda_pressed() -> void:
	if pag_number > min_pag_number and not busy:
		busy = true
		libro_container.find_child(str("pag", pag_number)).hide()
		pag_number -= 1
		
		# Animación de pasar página hacia atrás (reversa)
		libro_guia.play("default",-1,true)
		# Si la animación va en reversa, a veces necesitas reproducirla desde el final
		# libro_guia.frame = libro_guia.sprite_frames.get_frame_count("default") - 1
		
		await libro_guia.animation_finished
		
		fsm.change_to(str("pag", pag_number))
		busy = false
	pass # Replace with function body.
