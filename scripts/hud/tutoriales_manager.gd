extends CanvasLayer

# Referencias a los nodos del propio Pop-up
@onready var panel_tutorial = $PanelContainer
@onready var texto_explicativo = $PanelContainer/VBoxContainer/Label
@onready var boton_siguiente = $PanelContainer/VBoxContainer/Button

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

# Estructura de datos para los pasos del tutorial
var pasos: Array = []
var paso_actual: int = 0

func _ready():
	# Conectamos el botón de "Siguiente" para avanzar en el tutorial
	boton_siguiente.pressed.connect(_on_siguiente_pressed)
	panel_tutorial.hide() # Empezamos ocultos

# Función para iniciar el tutorial desde tu juego
func iniciar_tutorial(lista_de_pasos: Array):
	get_tree().paused = true
	pasos = lista_de_pasos
	paso_actual = 0
	if pasos.size() > 0:
		panel_tutorial.show()
		mostrar_paso()

func mostrar_paso():
	var datos_paso = pasos[paso_actual]
	texto_explicativo.text = datos_paso["texto"]
	var boton_objetivo = datos_paso["nodo_boton"] as Button
	
	if boton_objetivo:
		await get_tree().process_frame
		panel_tutorial.reset_size() 
		
		# Posición del botón en la pantalla
		var posicion_pantalla_boton = boton_objetivo.get_global_transform_with_canvas().origin
		
		animated_sprite_2d.global_position = boton_objetivo.global_position + boton_objetivo.size / 2
		
		# Cálculo de la posición ideal (debajo del botón)
		var posicion_final = posicion_pantalla_boton + Vector2(0, boton_objetivo.size.y + 10)
		
		# --- LIMITAR A LOS BORDES DE LA PANTALLA ---
		var limite_pantalla = get_viewport().get_visible_rect().size
		
		# Evitamos que se salga por la derecha o por abajo
		posicion_final.x = clamp(posicion_final.x, 0, limite_pantalla.x - panel_tutorial.size.x)
		posicion_final.y = clamp(posicion_final.y, 0, limite_pantalla.y - panel_tutorial.size.y)
		
		# Asignamos la posición segura
		panel_tutorial.global_position = posicion_final
func _on_siguiente_pressed():
	paso_actual += 1
	if paso_actual < pasos.size():
		mostrar_paso()
	else:
		finalizar_tutorial()

func finalizar_tutorial():
	panel_tutorial.hide()
	get_tree().paused = false
	queue_free() # Elimina el tutorial si ya terminó
