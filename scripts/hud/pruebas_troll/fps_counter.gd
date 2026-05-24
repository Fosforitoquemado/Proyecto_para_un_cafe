extends Label

var time_passed := 0.0

func _process(delta: float) -> void:
	time_passed += delta
	
	# Actualiza solo cada 0.5 segundos
	if time_passed >= 0.5:
		var fps = Engine.get_frames_per_second()
		text = "FPS: %d" % fps # Formato de entero
		
		# Opcional: Cambiar color según rendimiento
		if fps >= 60:
			modulate = Color.GREEN
		elif fps >= 30:
			modulate = Color.YELLOW
		else:
			modulate = Color.RED
			
		time_passed = 0.0
