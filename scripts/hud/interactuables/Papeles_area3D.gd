extends Area3D

var position_licencia
var position_cedula
var position_seguro

var ocupado = false

var uicontroller
var elementos_mesa

func _ready() -> void:
	uicontroller = get_tree().get_first_node_in_group("ui_manager")
	elementos_mesa = get_tree().get_first_node_in_group("elementos_mesa")
	var nodo_cedula = elementos_mesa.find_child("nodo_cedula")
	var nodo_licencia = elementos_mesa.find_child("nodo_licencia")
	var nodo_seguro = elementos_mesa.find_child("nodo_seguro")
	position_cedula = nodo_cedula.global_position
	position_licencia = nodo_licencia.global_position
	position_seguro = nodo_seguro.global_position
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
				var seguro = elementos_mesa.find_child("Documento_seguro")
				var tween = create_tween()
				tween.tween_property(cedula,"global_position",position_cedula,0.6)
				var tween2 = create_tween()
				tween2.tween_property(carnet,"global_position",position_licencia,0.6)
				var tween3 = create_tween()
				tween3.tween_property(seguro,"global_position",position_seguro,0.6)
				var personaje = GameManager.auto_dupe.get_node("nodo_personaje/personaje")
				var personaje_animator:AnimationPlayer = personaje.find_child("AnimationPlayer")
				personaje_animator.play("agarrar papeles")
				await personaje_animator.animation_finished
				personaje_animator.play("manejando")
				
