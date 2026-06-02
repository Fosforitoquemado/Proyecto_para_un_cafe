extends Area3D

var uicontroller
var state_machine
var yes_no_menu

func _ready() -> void:
	uicontroller = get_tree().get_first_node_in_group("ui_manager")
	state_machine = uicontroller.find_child("StateMachine")
	yes_no_menu = state_machine.find_child("yes_no_menu")

func _on_mouse_entered() -> void:
	if state_machine.current_state.name == "yes_no_menu":
		yes_no_menu.mostrar_progressbarmate()

func _on_mouse_exited() -> void:
	if state_machine.current_state.name == "yes_no_menu":
		yes_no_menu.ocultar_progressbarmate()
