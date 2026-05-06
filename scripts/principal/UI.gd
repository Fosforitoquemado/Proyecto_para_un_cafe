extends Control
class_name UIManager

@onready var CameraController: Node = $"../CameraController"

@export var autos_label: Label
@export var fallos_label: Label

@export var empezar: TextureRect

#elementos HUD
@export var inspeccion_menu: Control
@export var yes_no_menu: Control
@export var timer: ProgressBar

@export var camara_mesa: Node3D
#cedula
@export var cedula: Sprite3D
@export var dominio_cedula: Label3D
@export var modelo_cedula: Label3D
@export var vencimiento_cedula: Label3D

#licencia
@export var carnet: Sprite3D
@export var numero_licencia: Label3D
@export var apellido_licencia: Label3D
@export var nombre_licencia: Label3D
@export var fecha_nacimiento_licencia: Label3D
@export var vencimiento_licencia: Label3D

var active = false
var auto_on = false
var inspeccion_menu_active

func _ready() -> void:
	update_ui(GameManager.fallos,GameManager.autos_pasados,GameManager.max_fallos,GameManager.max_autos)

func update_ui(fallos, autos, max_fallos, max_autos):
	fallos_label.text = str("Fallos: ",fallos," / ",max_fallos)
	autos_label.text = "Autos: %d / %d" % [autos, max_autos]

func ver_documentos():
	cedula.visible = true
	carnet.visible = true
	yes_no_menu.visible = true
	
func ocultar_documentos():
	cedula.visible = false
	carnet.visible = false
	yes_no_menu.visible = false

func _on_button_pressed() -> void:
	if auto_on == false:
		auto_on = true
		timer._start_timer()
		GameManager.generar_auto()
		ver_documentos()
		empezar.visible = false
		CameraController.vista_normal()
		
	pass # Replace with function body.

func _on_yes_pressed() -> void:
	if active == false:
		active = true
		GameManager.auto_dupe.irse()
		timer._stop_timer()
		ocultar_documentos()
		await get_tree().create_timer(3.0).timeout
		if DocumentosGenerator.auto_ilegal == true:
			GameManager.sumar_fallo()
		else:
			GameManager.sumar_auto()
		GameManager.auto_dupe.queue_free()
		auto_on = false
		empezar.visible = true
		update_ui(GameManager.fallos,GameManager.autos_pasados,GameManager.max_fallos,GameManager.max_autos)
		active = false
	pass # Replace with function body.
func _on_no_pressed() -> void:
	if active == false:
		active = true
		timer._stop_timer()
		if DocumentosGenerator.auto_ilegal == false:
			GameManager.sumar_fallo()
		GameManager.auto_dupe.queue_free()
		auto_on = false
		ocultar_documentos()
		empezar.visible = true
		update_ui(GameManager.fallos,GameManager.autos_pasados,GameManager.max_fallos,GameManager.max_autos)
		active = false
	pass # Replace with function body.

func _on_inspeccion_pressed() -> void:
	inspeccion_menu_active = true
	yes_no_menu.visible = false
	inspeccion_menu.visible = true
	autos_label.visible = true
	fallos_label.visible = true
	pass # Replace with function body.

func _on_inspeccion_adelante_pressed() -> void:
	CameraController.ver_patente_adelante(GameManager.auto_dupe.find_child("camara_patente_adelante").global_position)
	pass # Replace with function body.

func _on_inspeccion_atras_pressed() -> void:
	
	CameraController.ver_patente_atras(GameManager.auto_dupe.find_child("camara_patente_atras").global_position)
	pass # Replace with function body.

func _on_inspeccion_vtv_pressed() -> void:
	CameraController.ver_vtv(GameManager.auto_dupe.find_child("camara_VTV").global_position)
	pass # Replace with function body.

func _on_inspeccion_mesa_pressed() -> void:
	CameraController.ver_escritorio(camara_mesa.global_position)
	pass # Replace with function body.

func _on_fov_slider_value_changed(value: float) -> void:
	CameraController.update_fov(value)
	pass # Replace with function body.

func _on_inspeccion_volver_pressed() -> void:
	visible = true
	CameraController.vista_normal()
	yes_no_menu.visible = true
	autos_label.visible = true
	fallos_label.visible = true
	inspeccion_menu.visible = false
	inspeccion_menu_active = false
	pass # Replace with function body.

func _on_inspeccion_compu_pressed() -> void:
	yes_no_menu.visible = false
	autos_label.visible = false
	fallos_label.visible = false
	###camera_3d.rotation = Vector3(0,deg_to_rad(45),0)
	###camera_3d.position = Vector3(1.8,0.7,1.5)
	###camera_3d.fov = 75
	inspeccion_menu.visible = false
	###pcsistema.camara()
	###pcsistema.toggle_use()
	pass # Replace with function body.
