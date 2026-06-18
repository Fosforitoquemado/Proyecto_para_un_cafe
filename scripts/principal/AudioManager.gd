extends Node

@onready var player = $AudioStreamPlayer

var click_sound = preload("res://sonidos/NUEVOS SONIDOS/Clicks/CLICK MOUSE CASERO.mp3")

var error_sound = preload("res://sonidos/HUD/ERROR/Error.wav")

func play_click():
	player.stream = click_sound
	player.play()

func play_pc_error():
	player.stream = error_sound
	player.play()
