extends SubViewportContainer

@onready var carnet_: AnimatedSprite2D = $SubViewport/carnet_
@onready var audio_stream_player: AudioStreamPlayer = $SubViewport/carnet_/AudioStreamPlayer
@onready var sub_viewport: SubViewport = $SubViewport

func star():
	visible = true
	carnet_.play("default")
	audio_stream_player.play()
	await get_tree().create_timer(0.7).timeout
	get_tree().quit()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sub_viewport.size = size
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
