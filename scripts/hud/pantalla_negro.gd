extends TextureRect

@export var hud:Control
@onready var dia: Label = $dia
@onready var objetivo: Label = $objetivo
@onready var stomp: AudioStreamPlayer = $stomp

func _ready() -> void:
	visible = true

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

func mostrar_objetivo(tiempo1,tiempo2):
	objetivo.show()
	objetivo.text = ""
	await get_tree().create_timer(tiempo1 / 3,false).timeout
	objetivo.text += "DINERO OBJETIVO DEL DIA: "
	stomp.play()
	await get_tree().create_timer(stomp.stream.get_length() + 1).timeout
	objetivo.text += str(GameManager.dinero_objetivo)
	stomp.play()
	var tween2 = create_tween()
	tween2.tween_property(objetivo,"modulate",Color(0.0, 0.0, 0.0, 0.0),tiempo2 + tiempo1 - (tiempo1 / 3) - stomp.stream.get_length() + 1)
	await get_tree().create_timer(tiempo2 + tiempo1 - (tiempo1 / 3) - stomp.stream.get_length() + 1,false).timeout
	objetivo.hide()

func comienzo_dia(tiempo1,tiempo2):
	dia.show()
	dia.text = str(hud.dia.nombre," ",hud.dia.fecha_hoy.dia," de junio de ",hud.dia.fecha_hoy.anio)
	print(dia.text)
	show()
	modulate = Color(0.0, 0.0, 0.0, 1.0)
	await get_tree().create_timer(tiempo1,false).timeout
	var tween1 = create_tween()
	tween1.tween_property(self,"modulate",Color(0.0, 0.0, 0.0, 0.0),tiempo2)
	var tween2 = create_tween()
	tween2.tween_property(dia,"modulate",Color(0.0, 0.0, 0.0, 0.0),tiempo2)
	await get_tree().create_timer(tiempo2,false).timeout
	hide()
	modulate = Color(0.0, 0.0, 0.0, 0.0)
	dia.modulate = Color(1.0, 1.0, 1.0, 1.0)
	dia.hide()
