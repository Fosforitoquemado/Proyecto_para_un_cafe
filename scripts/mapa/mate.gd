extends Node3D

@onready var animation_player: AnimationPlayer = $mate/AnimationPlayer

@onready var timer: ProgressBar = $"../../HUD/Hud_elementos/Timer"

var active = true

func _ready() -> void:
	pass # Replace with function body.


func _process(_delta: float) -> void:
	pass

func _on_mate_pressed() -> void:
	if active == true and timer.value > 30:
		active = false
		animation_player.play("TOMAR MATE")
		await  get_tree().create_timer(4).timeout
		timer._reduce_timer()
		active = true
		
	pass # Replace with function body.
