extends Node

@onready var tienda: UITIENDAManager = $"../HUD_tienda"

@onready var day_manager: Node = $"../DayManager"

var skip = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var state_machine = tienda.find_child("StateMachine")
	var dia = day_manager.get_day()
	var pantalla_negra = tienda.find_child("pantalla_negro")
	pantalla_negra.aclarar(2)
	await get_tree().process_frame
	state_machine.change_to("tienda")
	# CONTROL DE SEGURIDAD: Validamos que dialogostele no sea Nil y tenga la propiedad 'array'
	if dia.dialogostele == null:
		print_rich("[color=yellow]⚠️ ADVERTENCIA: El día actual no tiene ningún recurso de diálogos asignado en 'dialogostele'.[/color]")
		state_machine.change_to("main_view")
		return
	if not "array" in dia.dialogostele:
		print_rich("[color=orange]⚠️ ADVERTENCIA: 'dialogostele' existe, pero no contiene una variable llamada 'array'.[/color]")
		state_machine.change_to("main_view")
		return
	#if skip == false:
		#state_machine.change_to("main_view")
