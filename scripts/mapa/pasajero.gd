extends MeshInstance3D

const tamaniolabel = 52

@onready var label_mensaje: Label3D = $Nodo_mensaje/mensaje

func mostrar_mensaje(mensaje: String):
	label_mensaje.text = ""
	label_mensaje.font_size = tamaniolabel
	var tween = create_tween()
	tween.tween_property(label_mensaje,"font_size",label_mensaje.font_size - 20,1.0)
	for i in range(mensaje.length()):
		label_mensaje.text += mensaje[i]
		
		await  get_tree().create_timer(0.05).timeout
	
	print(mensaje)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(1).timeout
	mostrar_mensaje("me encanta argentina")
	await get_tree().create_timer(5).timeout
	mostrar_mensaje("me encanta argentina de nuevo")
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
