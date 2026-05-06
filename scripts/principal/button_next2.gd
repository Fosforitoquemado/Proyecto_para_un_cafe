extends Button
class_name Boton_Primario

@onready var node_main: Node3D = $"../../.."

@onready var camera_3d: Camera3D = $"../../../Camera3D"

#posicion camara
@onready var camara_mesa: Node3D = $"../../cedula/Camara_mesa"

#compu
@onready var pcsistema: PCStatic = $"../../../PCSISTEMA"

var auto_dupe

var active = false

func _ready() -> void:
	add_to_group("boton")
	pass # Replace with function body.


func _on_pressed() -> void:
	if get_meta("Auto_on") == false:
		set_meta("Auto_on", true)
		set_meta("Auto_ilegal_bool", false)
		
		#var num_auto_random = randi_range(0,autos_lista.size() - 1)
		#var auto = autos_lista.values()[num_auto_random]
		
		#auto_dupe = auto.instantiate()
		#pcsistema.pc_control.set_fecha_vencimiento(fecha_vencimiento_licencia)
		
		camera_3d.rotation = Vector3(0,deg_to_rad(45),0)
		
		#empezar.visible = false
		
		await get_tree().create_timer(3.0).timeout
		
		#yes_no_menu.visible = true
		#cedula.visible = true
		#carnet.visible = true
		
	else:
		print("ya hay auto")
		pass
	
