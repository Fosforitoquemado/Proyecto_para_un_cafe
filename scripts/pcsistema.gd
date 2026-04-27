extends Node3D
class_name PCStatic

var is_using:bool = true
@onready var boton_primario:Boton_Primario

@onready var camera_3d: Camera3D = $nodo_camara/Camera3D

@onready var sub_viewport: SubViewport = $SubViewport
@onready var pc_control: Control = $SubViewport/PCControl

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boton_primario = get_tree().get_first_node_in_group("boton")
	pc_control.PCSISTEM = self
	pass # Replace with function body.

func toggle_use():
	is_using = !is_using
func camara():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	camera_3d.current = true
func exit():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	boton_primario._on_inspeccion_pressed()

func set_fecha(fecha):
	pc_control.set_fecha(fecha)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event: InputEvent) -> void:
	if is_using:
		return
		
	if event is InputEventKey:
		if Input.is_action_just_pressed("ui_cancel"):
			toggle_use()
			exit()
			return
		else:
			sub_viewport.push_input(event)
			
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT or event.button_index == MOUSE_BUTTON_MIDDLE:
			var mouse_event = InputEventMouseButton.new()
			mouse_event.button_index = event.button_index
			mouse_event.pressed = event.pressed
			mouse_event.position = pc_control.pc_mouse_pos
			mouse_event.global_position = pc_control.pc_mouse_pos
			
			sub_viewport.push_input(mouse_event)
	
	elif event is InputEventMouseMotion:
		pc_control.pc_mouse_pos += event.relative
		pc_control.pc_mouse_pos.x = clamp(pc_control.pc_mouse_pos.x, 0.0, sub_viewport.size.x - 10.0)
		pc_control.pc_mouse_pos.y = clamp(pc_control.pc_mouse_pos.y, 0.0, sub_viewport.size.y - 10.0)
		pc_control.update_cursor_pos()
		pass
		
