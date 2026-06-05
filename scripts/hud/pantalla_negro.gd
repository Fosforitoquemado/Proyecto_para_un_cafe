extends TextureRect


func oscurecer(tiempo):
	show()
	modulate = Color(0.0, 0.0, 0.0, 0.0)
	var tween = create_tween()
	tween.tween_property(self,"modulate",Color(0.0, 0.0, 0.0, 1.0),tiempo)
	

func aclarar(tiempo):
	show()
	modulate = Color(0.0, 0.0, 0.0, 1.0)
	var tween3 = create_tween()
	tween3.tween_property(self,"modulate",Color(0.0, 0.0, 0.0, 0.0),tiempo)
	await get_tree().create_timer(tiempo,false).timeout
	hide()
	modulate = Color(0.0, 0.0, 0.0, 0.0)
