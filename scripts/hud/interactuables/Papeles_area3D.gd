extends Area3D

var ocupado = false

var uicontroller
var elementos_mesa

func _ready() -> void:
	uicontroller = get_tree().get_first_node_in_group("ui_manager")
	elementos_mesa = get_tree().get_first_node_in_group("elementos_mesa")
	pass # Replace with function body.

func _input_event(_camera, event, _position, _normal, _shape_idx):
	if ocupado:
		return
	if event is InputEventMouseButton:
		
		if event.pressed:
			var state_machine = uicontroller.find_child("StateMachine")
			if state_machine.current_state.name == "yes_no_menu" or state_machine.current_state.name == "inspeccion":
				ocupado = true
				uicontroller.papeles_on = true
				var cedula = elementos_mesa.find_child("Documento_cedula")
				var carnet = elementos_mesa.find_child("Documento_carnet")
				var tween = create_tween()
				tween.tween_property(cedula,"global_position",Vector3(1.115,0.4,1.28),0.6)
				var tween2 = create_tween()
				tween2.tween_property(carnet,"global_position",Vector3(1.0,0.4,1.28),0.6)
				var personaje = GameManager.auto_dupe.get_node("nodo_personaje/personaje")
				var personaje_animator:AnimationPlayer = personaje.find_child("AnimationPlayer")
				personaje_animator.play("agarrar papeles")
				
				await personaje_animator.animation_finished
				personaje_animator.play("manejando")
				
