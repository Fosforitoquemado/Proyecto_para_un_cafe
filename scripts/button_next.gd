extends Button

@onready var node_main: Node3D = $"../.."

@onready var label: Label = $"../Color"
@onready var fallos_label: Label = $"../Fallos"
@onready var autos_label: Label = $"../Autos"

@onready var auto = preload("res://scenes/car.tscn")
@onready var yes_no_menu: Control = $"../YES_NO_menu"

@onready var camera_3d: Camera3D = $"../../Camera3D"

@export var max_fallos : int = 3
@export var max_autos: int = 10

@onready var fallos : int = 0
@onready var autos : int = 0

@onready var colors = {
	"rojo": "ff1b13",
	"azul": "222bff",
	"verde": "1df428",
	"violeta": "5510c7",
	"naranja": "f67200",
}

var condicion_dia
var condicion_auto
var auto_dupe

var active = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	var num = randi_range(0,4)
	condicion_dia = colors.values()[num]
	label.text += str(colors.keys()[num])
	fallos_label.text = str("Fallos: ",fallos," / ",max_fallos)
	autos_label.text = str("Autos: ",autos," / ",max_autos)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if fallos >= 3:
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
	if autos >= 10:
		get_tree().change_scene_to_file("res://scenes/victoria.tscn")
	pass

func _on_pressed() -> void:
	if get_meta("Auto_on") == false:
		set_meta("Auto_on", true)
		
		var num = randi_range(0,4)
		
		auto_dupe = auto.instantiate()
		
		
		var materiall = auto_dupe.get_active_material(0).duplicate()
		materiall.albedo_color = Color(colors.values()[num])
		auto_dupe.set_surface_override_material(0, materiall)
		condicion_auto = colors.values()[num]
		node_main.add_child(auto_dupe)
		auto_dupe.global_position = Vector3(0.2,0,-2.0)
		camera_3d.rotation = Vector3(0,70,0)
		await get_tree().create_timer(1.5).timeout
		yes_no_menu.visible = true
		
		
		
	else:
		print("ya hay pasajero")
		pass
	


func _on_yes_pressed() -> void:
	if active == false:
		active = true
		autos += 1
		if condicion_auto == condicion_dia:
			fallos += 1
		auto_dupe.irse()
		await get_tree().create_timer(3.0).timeout
		auto_dupe.queue_free()
		set_meta("Auto_on", false)
		yes_no_menu.visible = false
		fallos_label.text = str("Fallos: ",fallos," / ",max_fallos)
		autos_label.text = str("Autos: ",autos," / ",max_autos)
		active = false
	pass # Replace with function body.

func _on_no_pressed() -> void:
	if active == false:
		active = true
		if condicion_auto != condicion_dia:
			fallos += 1
		auto_dupe.queue_free()
		set_meta("Auto_on", false)
		yes_no_menu.visible = false
		fallos_label.text = str("Fallos: ",fallos," / ",max_fallos)
		autos_label.text = str("Autos: ",autos," / ",max_autos)
		active = false
	pass # Replace with function body.
