extends Area3D

var ocupado = false

var hay_condicion = false

var uicontroller

func _ready() -> void:
	uicontroller = get_tree().get_first_node_in_group("ui_manager")
	var daymanager = get_tree().get_first_node_in_group("DayManager")
	var dia = daymanager.get_day()
	if "objetos_baul" in dia.documentos_habilitados:
		hay_condicion = true
	pass # Replace with function body.

func _input_event(_camera, event, _position, _normal, _shape_idx):
	if ocupado:
		return
	if event is InputEventMouseButton:
		if event.pressed and hay_condicion == true:
			var state_machine = uicontroller.find_child("StateMachine")
			if state_machine.current_state.name == "auto_atras" or state_machine.current_state.name == "auto_baul":
				state_machine.change_to("auto_baul")
			pass # Replace with function body.
