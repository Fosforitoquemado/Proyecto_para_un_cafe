extends PanelContainer

@onready var carnet_: AnimatedSprite2D = $carnet_
@onready var audio_stream_player: AudioStreamPlayer = $carnet_/AudioStreamPlayer

func star():
	carnet_.play("default")
	audio_stream_player.play()
	await get_tree().create_timer(0.7).timeout
	get_tree().quit()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
