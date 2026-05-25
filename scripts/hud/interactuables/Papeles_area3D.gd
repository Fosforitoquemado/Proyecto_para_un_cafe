extends Area3D

var ocupado = false

var uicontroller
var elementos_mesa

func _ready() -> void:
	uicontroller = get_tree().get_first_node_in_group("ui_manager")
	elementos_mesa = get_tree().get_first_node_in_group("elementos_mesa")
	pass # Replace with function body.

func _input_event(camera, event, position, normal, shape_idx):
	if ocupado:
		return
	if event is InputEventMouseButton:
		
		if event.pressed:
			var cedula = elementos_mesa.find_child("cedula")
			cedula.global_position = Vector3(1.115,0.4,1.28)
			var carnet = elementos_mesa.find_child("carnet")
			carnet.global_position = Vector3(1.0,0.4,1.28)
			var state_machine = uicontroller.find_child("StateMachine")
			state_machine.change_to("yes_no_menu")
