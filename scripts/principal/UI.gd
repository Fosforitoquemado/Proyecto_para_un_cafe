extends Control
class_name UIManager

@onready var pcsistema: PCStatic = $"../PCSISTEMA"

@onready var CameraController: Node = $"../CameraController"

@onready var mate: Node3D = $"../Elementos_mesa/MATE"

@onready var camara_mesa: Node3D = $"../Elementos_mesa/mesa/Camara_mesa"

@export var autos_label: Label
@export var fallos_label: Label
@export var dinero: Label

@export var empezar: TextureRect

#elementos HUD
@export var inspeccion_menu: Control
@export var yes_no_menu: Control
@export var timer: ProgressBar

var active = false
var auto_on = false
var inspeccion_menu_active

func _ready() -> void:
	update_ui()

func update_ui():
	fallos_label.text = str("Fallos: ",GameManager.fallos," / ",GameManager.max_fallos)
	autos_label.text = "Autos: %d / %d" % [GameManager.autos_pasados, GameManager.max_autos]
	dinero.text = str("Dinero: ",GameManager.dinero_player)

func _on_button_pressed() -> void:
	if auto_on == false:
		auto_on = true
		timer._start_timer()
		GameManager.generar_auto()
		yes_no_menu.visible = true
		empezar.visible = false
		CameraController.vista_normal()
		
	pass # Replace with function body.

func _on_yes_pressed() -> void:
	if active == false:
		active = true
		GameManager.auto_dupe.irse()
		timer._stop_timer()
		yes_no_menu.visible = false
		await get_tree().create_timer(3.0).timeout
		if DocumentosGenerator.auto_ilegal == true:
			GameManager.sumar_fallo()
			print("FALLASTE❌❌")
		else:
			GameManager.sumar_dinero_jugador(50)
			GameManager.sumar_auto()
			print("BIEN✅✅")
		GameManager.auto_dupe.queue_free()
		auto_on = false
		empezar.visible = true
		update_ui()
		GameManager.check_estado()
		active = false
	pass # Replace with function body.
func _on_no_pressed() -> void:
	if active == false:
		active = true
		timer._stop_timer()
		if DocumentosGenerator.auto_ilegal == false:
			print("FALLASTE❌❌")
			GameManager.sumar_fallo()
		else:
			GameManager.sumar_dinero_jugador(50)
			print("BIEN✅✅")
		GameManager.auto_dupe.queue_free()
		auto_on = false
		yes_no_menu.visible = false
		empezar.visible = true
		update_ui()
		GameManager.check_estado()
		active = false
	pass # Replace with function body.

func _on_coimear_pressed() -> void:
	if active == false:
		active = true
		timer._stop_timer()
		if DocumentosGenerator.auto_ilegal == false:
			print("FALLASTE❌❌")
			GameManager.sumar_fallo()
		else:
			GameManager.sumar_dinero_jugador(AutoGenerator._auto_data["dinero_coima"])
			print("BIEN✅✅")
		GameManager.auto_dupe.queue_free()
		auto_on = false
		yes_no_menu.visible = false
		empezar.visible = true
		update_ui()
		GameManager.check_estado()
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
	inspeccion_menu.visible = false
	pcsistema.camara()
	pcsistema.toggle_use()
	pass # Replace with function body.


func _on_mate_pressed() -> void:
	mate._on_mate_pressed()
	pass # Replace with function body.
