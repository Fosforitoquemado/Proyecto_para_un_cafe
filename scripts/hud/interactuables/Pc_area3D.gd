extends Area3D

var ocupado = false

@onready var pcsistema: PCStatic = $".."

var uicontroller

func _ready() -> void:
	uicontroller = get_tree().get_first_node_in_group("ui_manager")
	pass # Replace with function body.

func _input_event(_camera, event, _position, _normal, _shape_idx):
	if ocupado:
		return
	if event is InputEventMouseButton:
		
		if event.pressed:
			var state_machine = uicontroller.find_child("StateMachine")
			if state_machine.current_state.name == "yes_no_menu" or state_machine.current_state.name == "inspeccion" or state_machine.current_state.name == "main_view" or state_machine.current_state.name == "transicion":
				state_machine.change_to("pc")
				pcsistema.camara()
				pcsistema.toggle_use()
