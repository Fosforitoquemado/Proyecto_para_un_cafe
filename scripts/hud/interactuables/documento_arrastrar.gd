extends Area3D

# --- CONFIGURACIÓN DE LÍMITES (Modifícalos en el Inspector) ---
@export var LIMITE_X_MIN: float = 0.89
@export var LIMITE_X_MAX: float = 1.18

@export var LIMITE_Z_MIN: float = 1.2
@export var LIMITE_Z_MAX: float = 1.35
# -------------------------------------------------------------

var arrastrando: bool = false
var camara: Camera3D
var plano_arrastre: Plane

var uicontroller

func _ready() -> void:
	uicontroller = get_tree().get_first_node_in_group("ui_manager")
	# Conseguimos la cámara activa del nivel
	camara = get_viewport().get_camera_3d()

func _input_event(_camera: Camera3D, event: InputEvent, _position: Vector3, _normal: Vector3, _shape_idx: int) -> void:
	# Detectamos si el usuario hace clic izquierdo sobre el objeto
	var state_machine = uicontroller.find_child("StateMachine")
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and state_machine.current_state.name == "mesa":
		if event.pressed:
			arrastrando = true
			# Creamos el plano invisible orientado hacia la cámara a la altura actual del objeto
			plano_arrastre = Plane(camara.project_ray_normal(event.position), global_position)
			global_position.y = 0.5
			print("AAAAAAAAAAAA")
		else:
			print("BBBBBBBBBBBBBBBB")
			global_position.y = 0.4
			arrastrando = false
func _input(event: InputEvent) -> void:
	# Si soltamos el clic en cualquier parte de la pantalla, dejamos de arrastrar
	var state_machine = uicontroller.find_child("StateMachine")
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and not event.pressed and state_machine.current_state.name == "mesa":
		global_position.y = 0.4
		arrastrando = false
		
	# Si nos estamos moviendo y el objeto está seleccionado
	if event is InputEventMouseMotion and arrastrando:
		_mover_objeto_a_posicion_raton(event.position)

func _mover_objeto_a_posicion_raton(pos_raton: Vector2) -> void:
	# Proyectamos un rayo desde la pantalla hacia el mundo 3D
	var origen_rayo = camara.project_ray_origin(pos_raton)
	var direccion_rayo = camara.project_ray_normal(pos_raton)
	
	# Buscamos la intersección entre el rayo del mouse y nuestro plano invisible
	var punto_interseccion = plano_arrastre.intersects_ray(origen_rayo, direccion_rayo)
	
	if punto_interseccion != null:
		# 1. Aplicamos el límite en los costados (Eje X)
		var x_limitada = clamp(punto_interseccion.x, LIMITE_X_MIN, LIMITE_X_MAX)
		
		# 2. Aplicamos el límite en la profundidad (Eje Z)
		var z_limitada = clamp(punto_interseccion.z, LIMITE_Z_MIN, LIMITE_Z_MAX)
		
		# 3. El eje Y lo dejamos libre según el plano de la cámara para que mantenga la altura correcta
		var y_actual =  0.5
		
		# Movemos el objeto a la posición final calculada con los límites
		global_position = Vector3(x_limitada, y_actual, z_limitada)
