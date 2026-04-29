extends Node3D

@onready var tren = preload("res://scenes/mapa/tren.tscn")

@onready var node_main: Node3D = $".."

var tiempo_transcurrido = 0
var active = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func spawnear_tren():
		
		var tren_dupe = tren.instantiate()
		node_main.add_child(tren_dupe)
		#tren_dupe.global_position = Vector3(-3.65,0.9,-8.7)
		await get_tree().create_timer(30).timeout
		tren_dupe.queue_free()
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	#tiempo_transcurrido += delta
	#if tiempo_transcurrido > 1 and active == true:
		#print("try")
	if active == true:
		active = false
		var num = randi_range(30,180)
		await get_tree().create_timer(num).timeout
		print("try")
		spawnear_tren()
		active = false
		#tiempo_transcurrido = 0
