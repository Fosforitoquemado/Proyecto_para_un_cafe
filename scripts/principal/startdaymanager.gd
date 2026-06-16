extends Node

@onready var camera_controller: Node = $"../CameraController"
@onready var hud: UIManager = $"../HUD"

@onready var tele: Node3D = $"../tele"
@onready var tele_camara: Node3D = $"../tele/nodo_camara"

@onready var day_manager: Node = $"../DayManager"

var skip = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var state_machine = hud.find_child("StateMachine")
	var dia = day_manager.get_day()
	var dia_actual = day_manager.dia_actual
	print("DIA HOY: ",dia_actual)
	hud.find_child("pantalla_negro").comienzo_dia(4,3)
	GameManager.cargar_dia()
	await get_tree().create_timer(6.5,false).timeout
	state_machine.change_to("tele")
	
	camera_controller.ver_baul(tele_camara.global_position, tele_camara.global_rotation)
	camera_controller.update_fov(60)
	
	# CONTROL DE SEGURIDAD: Validamos que dialogostele no sea Nil y tenga la propiedad 'array'
	if dia.dialogostele == null:
		print_rich("[color=yellow]⚠️ ADVERTENCIA: El día actual no tiene ningún recurso de diálogos asignado en 'dialogostele'.[/color]")
		state_machine.change_to("main_view")
		return
	if not "array" in dia.dialogostele:
		print_rich("[color=orange]⚠️ ADVERTENCIA: 'dialogostele' existe, pero no contiene una variable llamada 'array'.[/color]")
		state_machine.change_to("main_view")
		return
	# Si pasa los controles, el bucle corre sin peligro de crash
	await get_tree().create_timer(1, false).timeout
	tele.prender_tele()
	await get_tree().create_timer(1, false).timeout
	for i in range(dia.dialogostele.array.size()):
		if skip == true:
			tele.apagar_tele()
			return
		var dialogo_actual = dia.dialogostele.array[i]
		var array_final = false
		if i == dia.dialogostele.array.size() - 1:
			array_final = true
			
		tele.mostrar_mensaje(
			dialogo_actual["texto"],
			dialogo_actual["tamanio_font"],
			dialogo_actual["tamanio_final"],
			dialogo_actual["tiempo_font"],
			dialogo_actual["tiempo_velocidad"],
			array_final
		)
		
		var tiempo_espera = dialogo_actual["tiempo_cambio_dialogo"] * 2
		await get_tree().create_timer(tiempo_espera, false).timeout
	tele.apagar_tele()
	
	if skip == false:
		state_machine.change_to("main_view")
