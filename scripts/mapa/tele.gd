extends Node3D

const tamaniolabel = 40

@onready var mesh_instance_3d: MeshInstance3D = $SubViewport/MeshInstance3D
@onready var mesh_instance_3d_texto: MeshInstance3D = $Nodo_mensaje/MeshInstance3D
@onready var pantalla: MeshInstance3D = $pantalla

@onready var label_mensaje: Label = $SubViewport2/PanelContainer/MarginContainer/Label

@onready var sub_viewport: SubViewport = $SubViewport2
@onready var panel_container: PanelContainer = $SubViewport2/PanelContainer

@export var pixels_to_meters: float = 0.004

@onready var soniditos: AudioStreamPlayer3D = $soniditos
@onready var despedida: AudioStreamPlayer3D = $despedida

func apagar_tele():
	panel_container.visible = false
	#pantalla.material_override.albedo_color = Color(0, 0, 0, 1)
	var tween1 = create_tween()
	tween1.tween_property(pantalla.material_override,"albedo_color",Color(0, 0, 0),0.1)
	var tween = create_tween()
	tween.tween_property(pantalla.material_overlay,"shader_parameter/global_alpha",0,0.1)
	#pantalla.material_overlay.set_shader_parameter("global_alpha", 0)
	
func prender_tele():
	panel_container.visible = true
	var tween1 = create_tween()
	tween1.tween_property(pantalla.material_override,"albedo_color",Color(1.0, 1.0, 1.0, 1.0),0.2)
	var tween = create_tween()
	tween.tween_property(pantalla.material_overlay,"shader_parameter/global_alpha",0.2,0.15)

func mostrar_mensaje(mensaje: String,tamanio_font,tamanio_final,tiempo_font,tiempo_velocidad,array_final):
	label_mensaje.text = ""
	label_mensaje.label_settings.font_size = tamanio_font
	
	var tween = create_tween()
	tween.tween_property(label_mensaje.label_settings,"font_size",tamanio_final,tiempo_font)
	if array_final == true:
		despedida.play()
	for i in range(mensaje.length()):
		label_mensaje.text += mensaje[i]
		if i % 2 == 0:
			var uno = randi_range(-35,35)
			var dos = randi_range(-16,16)
			mesh_instance_3d.rotation = Vector3(deg_to_rad(dos),deg_to_rad(uno),0)
			if array_final == false:
				soniditos.play()
			#label_mensaje.ajustar_fuente()
		
		await get_tree().create_timer(tiempo_velocidad, false).timeout
	
	print(mensaje)
	
	mesh_instance_3d.rotation = Vector3(0,0,0)

func _ready() -> void:
	panel_container.item_rect_changed.connect(_on_ui_size_changed)
	# Forzamos una actualización inicial
	#_on_ui_size_changed()

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
