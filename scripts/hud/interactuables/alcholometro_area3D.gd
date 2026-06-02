extends Area3D

var position_medidor_alcholemia

@export var nodo_alcholemia: Node3D
@export var medidor_alcholemia: MeshInstance3D
@export var num_alcohol: Label3D

@onready var documentos_generator: Node = $"../../../DocumentosGenerator"

var ocupado = false

var uicontroller

func _ready() -> void:
	uicontroller = get_tree().get_first_node_in_group("ui_manager")
	position_medidor_alcholemia = nodo_alcholemia.global_position
	pass # Replace with function body.

func _input_event(_camera, event, _position, _normal, _shape_idx):
	if ocupado:
		return
	if event is InputEventMouseButton:
		if event.pressed:
			var state_machine = uicontroller.find_child("StateMachine")
			if state_machine.current_state.name == "yes_no_menu" or state_machine.current_state.name == "inspeccion":
				if uicontroller.papeles_on == true and num_alcohol.text != documentos_generator.auto_data["alcholemia"]:
					ocupado = true
					var personaje = GameManager.auto_dupe.get_node("nodo_personaje/personaje")
					var nodo_alcholemia_personaje = personaje.get_node("Armature/Skeleton3D/BoneAttachment3D2/nodo_alcholemia").global_position
					var animationplayermedidor:AnimationPlayer = medidor_alcholemia.find_child("AnimationPlayer")
					animationplayermedidor.play("boquilla_poner")
					await animationplayermedidor.animation_finished
					var tween = create_tween()
					tween.tween_property(medidor_alcholemia,"global_position",nodo_alcholemia_personaje,0.6)
					var personaje_animator:AnimationPlayer = personaje.find_child("AnimationPlayer")
					personaje_animator.play("hacer_test")
					await get_tree().create_timer(1.2,false).timeout
					var tween2 = create_tween()
					tween2.tween_property(medidor_alcholemia,"global_position",position_medidor_alcholemia,0.6)
					personaje_animator.play("stop_test")
					await get_tree().create_timer(0.7,false).timeout
					animationplayermedidor.play("boquilla_sacar")
					await animationplayermedidor.animation_finished
					num_alcohol.text = documentos_generator.auto_data["alcholemia"]
					personaje_animator.play("manejando")
					ocupado = false
				
