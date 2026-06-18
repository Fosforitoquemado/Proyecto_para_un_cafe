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
@export var menu_windows:Control

@export var panel_errores:PanelContainer
@export var errores_label:PackedScene
@onready var exclamacion: MeshInstance3D = $"../../exclamacion"

@export var panel_vtv:PanelContainer
@export var panel_cedula:PanelContainer
@export var panel_licencia:PanelContainer
@export var panel_seguro:PanelContainer
@export var panel_permiso:PanelContainer
@export var panel_instruccion:PanelContainer

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
@export var panel_isntrucciones: PanelContainer

@export var icono_vtv:TextureRect
@export var icono_cedula:TextureRect
@export var icono_licencia:TextureRect
@export var icono_seguro:TextureRect
@export var icono_permiso:TextureRect

@export var panel_windows:Array[DraggablePanelContainer]

@onready var barra_de_tareas: GridContainer = $barra_de_tareas

@onready var fsm: Node = $StateMachine
@onready var libro_guia: AnimatedSprite2D = $PanelContainer_instrucciones/libro_guia

var basededatos_active = false

var tiempo_de_carga

var busy: bool = false
var pag_number = 1
var min_pag_number = 1
var max_pag_number = 7

var ventanas:Dictionary = {}

var pc_mouse_pos:Vector2 = Vector2.ZERO

func _ready() -> void:
	ventanas.clear()
	
	var dia = day_manager.get_day()
	
	tiempo_de_carga = dia.config["tiempo_de_carga"]
	icono_vtv.hide()
	icono_cedula.hide()
	icono_licencia.hide()
	icono_seguro.hide()
	icono_permiso.hide()
	panel_isntrucciones.hide()
	menu_windows.hide()
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
	panel_errores.visible = false
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
	menu_windows.hide()
	#for i in ventanas:
		#ventanas[i].queue_free()
	#ventanas.clear()

func borrar_errores():
	exclamacion.visible = false
	var vbox = panel_errores.find_child("VBoxContainer")
	if vbox.get_children() != null:
		for i in vbox.get_children():
			i.queue_free()

func agregar_errores(errores):
	exclamacion.visible = true
	panel_errores.visible = true
	for i in errores.size():
		var errores_labels = errores_label.instantiate()
		var vbox = panel_errores.find_child("VBoxContainer")
		vbox.add_child(errores_labels)
		errores_labels.text = errores[i]
	for i in ventanas:
		ventanas[i].queue_free()
	ventanas.clear()
	var errores_icon: TextureRect = $Iconos/Errores_icon
	agregar_icono(errores_icon,"Errores_icon")
	panel_vtv.hide()
	panel_cedula.hide()
	panel_licencia.hide()
	panel_seguro.hide()
	panel_permiso.hide()

func agregar_icono(icono,nombre):
	if ventanas.size() < GameManager.max_ventanas:
		var dupe:TextureRect = icono.duplicate()
		dupe.set_script(null)
		ventanas.merge({nombre: dupe})
		barra_de_tareas.add_child(ventanas[nombre])
		dupe.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		dupe.size_flags_vertical = Control.SIZE_EXPAND_FILL
		
		for i in dupe.get_children():
			i.queue_free()

func borrar_icono(nombre):
	if nombre in ventanas:
		ventanas[nombre].queue_free()
		ventanas.erase(nombre)

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

func _on_apagar_pc_pressed() -> void:
	PCSISTEM.exit()
	reset_pc()
	pass # Replace with function body.

func _on_button_flecha_derecha_pressed() -> void:
	if pag_number < max_pag_number and not busy:
		busy = true
		pag_number += 1
		# Animación de pasar página hacia adelante
		libro_guia.play("default")
		fsm.change_to("transicion")
	pass # Replace with function body.

func _on_button_flecha_izquierda_pressed() -> void:
	if pag_number > min_pag_number and not busy:
		busy = true
		pag_number -= 1
		# Animación de pasar página hacia atrás (reversa)
		libro_guia.play("default",-1,true)
		fsm.change_to("transicion")
	pass # Replace with function body.

func _on_boton_windows_pressed() -> void:
	if menu_windows.visible == true:
		menu_windows.hide()
	else:
		menu_windows.show()
	pass # Replace with function body.
