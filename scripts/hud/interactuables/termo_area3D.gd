extends Area3D

var uicontroller

func _ready() -> void:
	uicontroller = get_tree().get_first_node_in_group("ui_manager")
	pass # Replace with function body.

func _on_mouse_entered() -> void:
	var state_machine = uicontroller.find_child("StateMachine")
	var yes_no_menu = state_machine.find_child("yes_no_menu")
	if state_machine.current_state.name == "yes_no_menu":
		yes_no_menu.mostrar_progressbarmate()
	pass # Replace with function body.


func _on_mouse_exited() -> void:
	var state_machine = uicontroller.find_child("StateMachine")
	var yes_no_menu = state_machine.find_child("yes_no_menu")
	if state_machine.current_state.name == "yes_no_menu":
		yes_no_menu.ocultar_progressbarmate()
	pass # Replace with function body.
