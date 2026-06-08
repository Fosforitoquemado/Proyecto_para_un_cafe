extends Control
class_name UITIENDAManager

@onready var state_machine: Node = $StateMachine
@onready var finaldaymanager: Node = $"../Finaldaymanager"

@onready var day_manager: Node = $"../DayManager"

#elementos HUD

var dia

var auto_on = false
var auto_out = false
var auto_called = false
var papeles_on = false

func _ready() -> void:
	update_ui()
	dia = day_manager.get_day()

func update_ui():
	pass

func _on_elementos_mesa_auto_ready() -> void:
	state_machine.change_to("yes_no_menu")
	auto_on = true
	pass # Replace with function body.


func _on_elementos_mesa_auto_out() -> void:
	state_machine.change_to("main_view")
	auto_out = true
	pass # Replace with function body.
