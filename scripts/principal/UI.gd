extends Control
class_name UIManager

@onready var state_machine: Node = $StateMachine

@onready var CameraController: Node = $"../CameraController"
@onready var startdaymanager: Node = $"../Startdaymanager"
@onready var day_manager: Node = $"../DayManager"

@export var autos_label: Label
@export var fallos_label: Label
@export var dinero_label: Label

#elementos HUD
@export var hud_elementos: Control
@export var inspeccion_menu: Control
@export var timer: ProgressBar

var dia

var auto_on = false
var auto_out = false
var papeles_on = false

func _ready() -> void:
	update_ui()
	dia = day_manager.get_day()
	timer.max_value = dia.tiempo_limite

func update_ui():
	fallos_label.text = str("Fallos: ",GameManager.fallos," / ",GameManager.max_fallos)
	autos_label.text = "Autos: %d / %d" % [GameManager.autos_pasados, GameManager.max_autos]
	dinero_label.text = str("Dinero: ",GameManager.dinero)

func _on_fov_slider_value_changed(value: float) -> void:
	CameraController.update_fov(value)
	pass # Replace with function body.

func _on_elementos_mesa_auto_ready() -> void:
	state_machine.change_to("yes_no_menu")
	auto_on = true
	pass # Replace with function body.


func _on_elementos_mesa_auto_out() -> void:
	auto_out = true
	auto_on = false
	if GameManager.tiempo < GameManager.tiempo_dia_total:
		state_machine.change_to("main_view")
	pass # Replace with function body.
