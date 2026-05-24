extends Control
class_name UIManager

@onready var state_machine: Node = $StateMachine

@onready var CameraController: Node = $"../CameraController"
@onready var startdaymanager: Node = $"../Startdaymanager"

@export var autos_label: Label
@export var fallos_label: Label
@export var dinero_label: Label

#elementos HUD
@export var hud_elementos: Control
@export var inspeccion_menu: Control
@export var timer: ProgressBar

var auto_on = false

func _ready() -> void:
	update_ui()

func update_ui():
	fallos_label.text = str("Fallos: ",GameManager.fallos," / ",GameManager.max_fallos)
	autos_label.text = "Autos: %d / %d" % [GameManager.autos_pasados, GameManager.max_autos]
	dinero_label.text = str("Dinero: ",GameManager.dinero_player)


func _on_fov_slider_value_changed(value: float) -> void:
	CameraController.update_fov(value)
	pass # Replace with function body.
