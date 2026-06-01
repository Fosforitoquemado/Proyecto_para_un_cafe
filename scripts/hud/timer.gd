extends ProgressBar

@export var HUD:Control
@export var statemachine:Node
@export var yes_no_menu: UIState

var timer_bool

var tiempo_transcurrido: float = 0.0

func _start_timer():
	timer_bool = true

func _pause_timer():
	timer_bool = false

func _stop_timer():
	timer_bool = false
	tiempo_transcurrido = 0.0
	value = tiempo_transcurrido

func _reduce_timer(num):
	tiempo_transcurrido -= num
	tiempo_transcurrido = clamp(tiempo_transcurrido,0,tiempo_transcurrido)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timer_bool == true:
		tiempo_transcurrido += delta
		value = tiempo_transcurrido
		if value == max_value and statemachine.processing == false:
			statemachine.change_to("yes_no_menu")
			yes_no_menu._on_yes_pressed()
			#GameManager.finalizar_dia()
			#get_tree().change_scene_to_file("res://scenes/hud/game_over.tscn")
	else:
		pass
	if value >= ((max_value * 80) / 100):
		modulate = Color(1.0, 0.0, 0.0, 1.0)
	elif value >= ((max_value * 50) / 100):
		modulate = Color(1.0, 1.0, 0.0, 1.0)
	else:
		modulate = Color(0.0, 1.0, 0.0, 1.0)
