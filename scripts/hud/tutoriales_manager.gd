extends CanvasLayer

# Referencias a los nodos del propio Pop-up
@onready var panel_tutorial = $PanelContainer
@onready var texto_explicativo = $PanelContainer/VBoxContainer/Label
@onready var boton_siguiente = $PanelContainer/VBoxContainer/Button

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@export var tiempo_espera = 3.0

# Estructura de datos para los pasos del tutorial
var pasos: Array = []
var posiciones: Array = []
var paso_actual: int = 0

var timer = false
var tiempo = 0.0

func _process(_delta: float) -> void:
	pass
	#if timer:
		#tiempo += delta
		#if tiempo >= tiempo_espera:
			#_on_siguiente_pressed()

func _ready():
	# Conectamos el botón de "Siguiente" para avanzar en el tutorial
	boton_siguiente.pressed.connect(_on_siguiente_pressed)
	panel_tutorial.hide() # Empezamos ocultos

# Función para iniciar el tutorial desde tu juego
func iniciar_tutorial(lista_de_pasos: Array,lista_de_posicines: Array):
	GameManager.paused = true
	get_tree().paused = true
	pasos = lista_de_pasos
	posiciones = lista_de_posicines
	paso_actual = 0
	if pasos.size() > 0:
		panel_tutorial.show()
		for paso in pasos:
			var boton_objetivo = paso["nodo_boton"] as Button
			if boton_objetivo.get_parent().is_class("TextureRect") and boton_objetivo.is_class("Button"):
				var texture = boton_objetivo.get_parent()
				texture.hide()
		mostrar_paso()

func mostrar_paso():
	timer = true
	var datos_paso = pasos[paso_actual]
	var datos_posiciones = posiciones[paso_actual]
	texto_explicativo.text = datos_paso["texto"]
	var boton_objetivo = datos_paso["nodo_boton"] as Button
	if boton_objetivo:
		
		panel_tutorial.reset_size() 
		
		# Posición del botón en la pantalla
		var posicion_pantalla_boton = boton_objetivo.get_global_transform_with_canvas().origin
		
		animated_sprite_2d.global_position = boton_objetivo.global_position + boton_objetivo.size / 2
		
		# Cálculo de la posición ideal (debajo del botón)
		var posicion_final
		if datos_posiciones["direccion"] == "arriba":
			posicion_final = posicion_pantalla_boton + Vector2(0, boton_objetivo.size.y - boton_objetivo.size.y * 2)
		elif datos_posiciones["direccion"] == "abajo":
			posicion_final = posicion_pantalla_boton + Vector2(0, boton_objetivo.size.y + 10)
		elif datos_posiciones["direccion"] == "izq":
			posicion_final = posicion_pantalla_boton + Vector2(-400, boton_objetivo.size.y - 100)
		elif datos_posiciones["direccion"] == "der":
			posicion_final = posicion_pantalla_boton + Vector2(400, boton_objetivo.size.y - 100)
		elif datos_posiciones["direccion"] == "pixeles":
			posicion_final = posicion_pantalla_boton + Vector2(boton_objetivo.size.x + datos_posiciones["pixeles_x"], boton_objetivo.size.y + datos_posiciones["pixeles_y"])
		# --- LIMITAR A LOS BORDES DE LA PANTALLA ---
		var limite_pantalla = get_viewport().get_visible_rect().size
		
		# Evitamos que se salga por la derecha o por abajo
		posicion_final.x = clamp(posicion_final.x, 0, limite_pantalla.x - panel_tutorial.size.x)
		posicion_final.y = clamp(posicion_final.y, 0, limite_pantalla.y - panel_tutorial.size.y)
		
		# Asignamos la posición segura
		panel_tutorial.global_position = posicion_final
		
	if boton_objetivo.get_parent().is_class("TextureRect"):
		var texture = boton_objetivo.get_parent()
		texture.show()
		
	print(datos_paso["automatico"])
	if datos_paso["automatico"] == true:
		await get_tree().create_timer(tiempo_espera).timeout
		_on_siguiente_pressed()
		print("awaited")
	else:
		pass
func _on_siguiente_pressed():
	paso_actual += 1
	tiempo = 0.0
	timer = false
	if paso_actual < pasos.size():
		mostrar_paso()
	else:
		finalizar_tutorial()

func finalizar_tutorial():
	panel_tutorial.hide()
	pasos = []
	posiciones= []
	paso_actual = 0
	GameManager.paused = false
	get_tree().paused = false
	queue_free() # Elimina el tutorial si ya terminó
