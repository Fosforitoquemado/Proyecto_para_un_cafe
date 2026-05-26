extends Area3D

var ocupado = false

@onready var pcsistema: PCStatic = $".."

var uicontroller

func _ready() -> void:
	uicontroller = get_tree().get_first_node_in_group("ui_manager")
	pass # Replace with function body.

func _input_event(camera, event, position, normal, shape_idx):
	if ocupado:
		return
	if event is InputEventMouseButton:
		
		if event.pressed and uicontroller.auto_on == true:
			print("COMPUTADORA")
			var state_machine = uicontroller.find_child("StateMachine")
			if state_machine.current_state.name == "yes_no_menu" or state_machine.current_state.name == "inspeccion":
				state_machine.change_to("pc")
				pcsistema.camara()
				pcsistema.toggle_use()
