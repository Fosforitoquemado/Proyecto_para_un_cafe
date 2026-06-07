extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func irse():
	animation_player.play("ida")

func abrir_baul():
	animation_player.play("abrir_baul")
func cerrar_baul():
	animation_player.play("cerrar_baul")

const tamaniolabel = 40

#@onready var mesh_instance_3d: MeshInstance3D = $SubViewport/MeshInstance3D
@onready var mesh_instance_3d_texto: MeshInstance3D = $Nodo_mensaje/MeshInstance3D

@onready var label_mensaje: Label = $Nodo_mensaje/SubViewport2/PanelContainer/MarginContainer/Label

@onready var sub_viewport: SubViewport = $Nodo_mensaje/SubViewport2
@onready var panel_container: PanelContainer = $Nodo_mensaje/SubViewport2/PanelContainer

@export var pixels_to_meters: float = 0.005

@onready var soniditos: AudioStreamPlayer3D = $Nodo_mensaje/soniditos
@onready var despedida: AudioStreamPlayer3D = $Nodo_mensaje/despedida

# 1. Definimos el ancho máximo en píxeles que permitiremos en X
@export var letters_scale:int = 10
@export var max_width_x: float = 400.0

func mostrar_mensaje(mensaje: String,tamanio_font,tamanio_final,tiempo_font,tiempo_velocidad,array_final):
	panel_container.visible = true
	
	label_mensaje.text = ""
	label_mensaje.label_settings.font_size = tamanio_font
	
	var tween = create_tween()
	tween.tween_property(label_mensaje.label_settings,"font_size",tamanio_final,tiempo_font)
	if array_final == true:
		despedida.play()
	for i in range(mensaje.length()):
		label_mensaje.text += mensaje[i]
		#if label_mensaje.text.length() * letters_scale < max_width_x:
			#panel_container.size.x = label_mensaje.text.length() * letters_scale
			#print("panel: ", panel_container.size)
		#else:
			#panel_container.size.x = max_width_x
		#sub_viewport.size.x = panel_container.size.x
		#mesh_instance_3d_texto.mesh.size.y = panel_container.size.y * pixels_to_meters
		#print(mesh_instance_3d_texto.mesh.size)
		#print("subviewport: ", sub_viewport.size)
		if i % 2 == 0:
			var _uno = randi_range(-35,35)
			var _dos = randi_range(-16,16)
			#mesh_instance_3d.rotation = Vector3(deg_to_rad(dos),deg_to_rad(uno),0)
			if array_final == false:
				soniditos.play()
			#label_mensaje.ajustar_fuente()
		
		await  get_tree().create_timer(tiempo_velocidad, false).timeout
	
	print(mensaje)
	
	#mesh_instance_3d.rotation = Vector3(0,0,0)

func ocultar_mensaje():
	panel_container.visible = false
	
func _on_ui_size_changed() -> void:
	# 1. Obtenemos el tamaño mínimo que requiere la UI para mostrar todo el texto
	var new_size: Vector2 = panel_container.get_combined_minimum_size()
	# Evitamos errores si el tamaño es cero
	if new_size.x == 0 or new_size.y == 0:
		return
	# 2. Ajustamos el tamaño del SubViewport para que coincida exactamente
	sub_viewport.size = new_size
	# 3. Ajustamos el tamaño del QuadMesh en el espacio 3D aplicando el factor de escala
	if mesh_instance_3d_texto.mesh is QuadMesh:
		mesh_instance_3d_texto.mesh.size = new_size * pixels_to_meters
		mesh_instance_3d_texto.mesh.center_offset.y = panel_container.size.y / 1000
