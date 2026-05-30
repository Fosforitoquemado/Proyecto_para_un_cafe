extends Node3D

@onready var animation_player: AnimationPlayer = $mate/AnimationPlayer

func tomar_mate():
	animation_player.play("TOMAR MATE")
