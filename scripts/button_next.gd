extends Button

@onready var node_main: Node3D = $"../.."

@onready var label: Label = $"../Color"
@onready var fallos_label: Label = $"../Fallos"
@onready var pasajeros_label: Label = $"../Pasajeros"

@onready var pasajero = preload("res://scenes/car.tscn")
@onready var yes_no_menu: Control = $"../YES_NO_menu"

@onready var camera_3d: Camera3D = $"../../Camera3D"

@export var max_fallos : int = 3
@export var max_pasajeros: int = 10

@onready var fallos : int = 0
@onready var pasajeros : int = 0

@onready var colors = {
	"rojo": "ff1b13",
	"azul": "222bff",
	"verde": "1df428",
	"violeta": "5510c7",
	"naranja": "f67200",
}

var condicion_dia
var condicion_pasajero
var pasajero_dupe

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var num = randi_range(0,4)
	condicion_dia = colors.values()[num]
	label.text += str(colors.keys()[num])
	fallos_label.text = str("Fallos: ",fallos," / ",max_fallos)
	pasajeros_label.text = str("Pasajeros: ",pasajeros," / ",max_pasajeros)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fallos >= 3:
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	if pasajeros >= 10:
		get_tree().change_scene_to_file("res://scenes/victoria.tscn")
	pass

func _on_pressed() -> void:
	if get_meta("pasajero_on") == false:
		set_meta("pasajero_on", true)
		
		var num = randi_range(0,4)
		
		pasajero_dupe = pasajero.instantiate()
		for i in 5:
			
			var materiall = pasajero_dupe.get_active_material(i).duplicate()
			materiall.albedo_color = Color(colors.values()[num])
			pasajero_dupe.set_surface_override_material(i, materiall)
		condicion_pasajero = colors.values()[num]
		node_main.add_child(pasajero_dupe)
		pasajero_dupe.global_position = Vector3(0.2,0,-2.0)
		
		yes_no_menu.visible = true
		camera_3d.rotation = Vector3(0,70,0)
		
		
	else:
		print("ya hay pasajero")
		pass
	


func _on_yes_pressed() -> void:
	pasajeros += 1
	if condicion_pasajero == condicion_dia:
		fallos += 1
	pasajero_dupe.queue_free()
	set_meta("pasajero_on", false)
	yes_no_menu.visible = false
	fallos_label.text = str("Fallos: ",fallos," / ",max_fallos)
	pasajeros_label.text = str("Pasajeros: ",pasajeros," / ",max_pasajeros)
	pass # Replace with function body.

func _on_no_pressed() -> void:
	if condicion_pasajero != condicion_dia:
		fallos += 1
	pasajero_dupe.queue_free()
	set_meta("pasajero_on", false)
	yes_no_menu.visible = false
	fallos_label.text = str("Fallos: ",fallos," / ",max_fallos)
	pasajeros_label.text = str("Pasajeros: ",pasajeros," / ",max_pasajeros)
	pass # Replace with function body.
