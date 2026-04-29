extends Node3D

@onready var animation_player: AnimationPlayer = $mate/AnimationPlayer

@onready var timer: ProgressBar = $"../Timer"

var active = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_mate_pressed() -> void:
	if active == true and timer.value > 30:
		active = false
		animation_player.play("TOMAR MATE")
		await  get_tree().create_timer(4).timeout
		timer._reduce_timer()
		active = true
		
	pass # Replace with function body.
