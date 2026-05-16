extends ProgressBar

var timer_bool

var tiempo_transcurrido: float = 0.0

func _start_timer():
	timer_bool = true

func _stop_timer():
	timer_bool = false
	tiempo_transcurrido = 0.0
	value = tiempo_transcurrido

func _reduce_timer():
	if tiempo_transcurrido >= 30:
		tiempo_transcurrido -= 30

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if timer_bool == true:
		tiempo_transcurrido += delta
		value = tiempo_transcurrido
		if value == max_value:
			GameManager.reset()
			get_tree().change_scene_to_file("res://scenes/hud/game_over.tscn")
	else:
		pass
