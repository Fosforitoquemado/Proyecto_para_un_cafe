extends Node

@export var initial_state: UIState

var current_state: UIState
var states: Dictionary = {}

# La pila que guardará los nombres de los estados anteriores
var _state_history: Array[String] = []

func _ready() -> void:
	for child in get_children():
		if child is UIState:
			states[child.name.to_lower()] = child
			child.fsm = self

	if initial_state:
		# Iniciamos el primer estado sin guardarlo en el historial
		_change_state(initial_state.name)

func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)

# 1. FUNCIÓN PÚBLICA: Para avanzar a un menú nuevo
func change_to(target_state_name: String) -> void:
	# Si ya hay un estado activo, lo guardamos en el historial antes de ir al nuevo
	if current_state:
		_state_history.append(current_state.name)
	if _state_history.size() > 5:
		_state_history.pop_front()
	_change_state(target_state_name)

# 2. FUNCIÓN PÚBLICA: Para regresar al menú anterior
func back() -> void:
	if _state_history.is_empty():
		print("No hay menús anteriores en el historial.")
		return
	# Sacamos el último estado guardado (.pop_back() lo devuelve y lo borra de la lista)
	var previous_state_name = _state_history.pop_back()
	_change_state(previous_state_name)

# 3. FUNCIÓN INTERNA: Hace el cambio real de nodos (limpieza de código repetido)
func _change_state(target_state_name: String) -> void:
	var target_key = target_state_name.to_lower()
	
	if not states.has(target_key):
		push_warning("El estado '" + target_state_name + "' no existe.")
		return

	if current_state:
		current_state.exit()

	current_state = states[target_key]
	current_state.enter()
	#print("UI Estado: ", current_state.name, " | Historial restante: ", _state_history)
