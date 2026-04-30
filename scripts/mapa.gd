extends Node3D

@onready var tren = preload("res://scenes/mapa/tren.tscn")

@onready var bondi = preload("res://scenes/mapa/bondi.tscn")

@onready var node_main: Node3D = $".."

var tiempo_transcurrido = 0
var active_tren = true
var active_bondi = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func spawnear_tren():
	if active_tren:
		var num = randi_range(30,180)
		await get_tree().create_timer(num).timeout
		print("viene tren")
		var tren_dupe = tren.instantiate()
		node_main.add_child(tren_dupe)
		#tren_dupe.global_position = Vector3(-3.65,0.9,-8.7)
		await get_tree().create_timer(30).timeout
		tren_dupe.queue_free()
		active_tren = true

func spawnear_bondi():
		
	if active_bondi:
		var num = randi_range(20,60)
		await get_tree().create_timer(num).timeout
		print("viene bondi")
		var bondi_dupe = bondi.instantiate()
		node_main.add_child(bondi_dupe)
		#tren_dupe.global_position = Vector3(-3.65,0.9,-8.7)
		await get_tree().create_timer(15).timeout
		bondi_dupe.queue_free()
		active_bondi = true
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	#tiempo_transcurrido += delta
	#if tiempo_transcurrido > 1 and active == true:
		#print("try")
	if active_bondi == true:
		spawnear_bondi()
		active_bondi = false
		
	if active_tren == true:
		spawnear_tren()
		active_tren = false
		
		
		#tiempo_transcurrido = 0

		
