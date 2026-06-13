extends MeshInstance3D

#reloj
@export var reloj_label:Label3D
@export var alarma:AudioStreamPlayer3D
@export var sprite:AnimatedSprite3D

@export var hora_inicio := 6
@export var hora_fin := 17

var duracion_dia
var hora_actual

var ready_ = true

func _ready() -> void:
	duracion_dia = GameManager.tiempo_dia_total # segundos reales
	hora_actual = hora_inicio
	print("HORAAAAAA",reloj_label.text)

func _process(_delta):
	# Calculamos el porcentaje de progreso del día (va de 0.0 a 1.0)
	var progreso: float = clamp(GameManager.tiempo / GameManager.tiempo_dia_total, 0.0, 1.0)
	
	# Mapeamos ese progreso (0 a 1) al rango de horas real (ej: 6 a 18)
	hora_actual = remap(progreso, 0.0, 1.0, hora_inicio, hora_fin)
	
	# Opcional: Mostrar la hora formateada de manera amigable
	var horas: int = int(hora_actual)
	# Extraemos los decimales de la hora para convertirlos en minutos (0.5 horas = 30 minutos)
	var minutos: int = int((hora_actual - horas) * 60)
	
	# Formatea con ceros a la izquierda (ej: "06:05")
	var texto_reloj: String = "%02d:%02d" % [horas, minutos]
	reloj_label.text = texto_reloj

	if GameManager.tiempo >= GameManager.tiempo_dia_total and ready_ == true:
		ready_ = false
		alarma.play()
		sprite.show()
		sprite.play("default")
		await get_tree().create_timer(alarma.stream.get_length() + 2, false).timeout 
		sprite.hide()
