extends Node

@onready var player = $AudioStreamPlayer

var click_sound = preload("res://sonidos/NUEVOS SONIDOS/CLICK.mp3")

func play_click():
	player.stream = click_sound
	player.play()
