extends Node3D

@export var objetosbaul:ObjetoArrayResource = preload("res://recursos/objetosbaularray/todos.tres")

@onready var nodo_baul_grande: Node3D = $armazon/nodo_baul_grande
@onready var nodo_baul_mediano: Node3D = $armazon/nodo_baul_mediano_izq

@onready var text_edit: TextEdit = $TextEdit

@onready var label: Label = $Label

var tiempo = 0.0

var random = false
var objeto_dupe

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = str("MAX: ",objetosbaul.array.size() - 1)
	pass # Replace with function body.


func generar():
	
	var num_objeto_random = randi_range(0,objetosbaul.array.size() - 1)
	
	var objeto = objetosbaul.array[num_objeto_random].escena
	var nombre = objetosbaul.array[num_objeto_random].nombre
	
	var objeto_tamanio = objetosbaul.array[num_objeto_random].tamanio
	var objeto_dupe = objeto.instantiate()
	
	print("El objeto se genero📦✅: ",nombre)
	
	nodo_baul_grande.add_child(objeto_dupe)
	#objeto_dupe.position = GameManager.auto_dupe.find_child("nodo_baul").position
	await get_tree().create_timer(2).timeout
	objeto_dupe.queue_free()
	print("El objeto se borro❌📦: ",nombre)
	return objeto

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if random == true:
		tiempo += delta
	if tiempo >= 2.2 and random == true:
		generar()
		tiempo = 0
	pass


func _on_button_pressed() -> void:
	var armazon: MeshInstance3D = $armazon
	armazon.abrir_baul()
	pass # Replace with function body.


func _on_button_2_pressed() -> void:
	var armazon: MeshInstance3D = $armazon
	armazon.cerrar_baul()
	pass # Replace with function body.


func _on_button_3_pressed() -> void:
	random = !random
	print(random)
	pass # Replace with function body.


func _on_button_4_pressed() -> void:
	var num_objeto_random = int(text_edit.text)
	if num_objeto_random <= objetosbaul.array.size() - 1:
	
		var objeto = objetosbaul.array[num_objeto_random].escena
		var nombre = objetosbaul.array[num_objeto_random].nombre
	
		var objeto_tamanio = objetosbaul.array[num_objeto_random].tamanio
		objeto_dupe = objeto.instantiate()
	
		print("El objeto se genero📦✅: ",nombre)
		if objeto_tamanio == "grande":
			nodo_baul_grande.add_child(objeto_dupe)
		else:
			nodo_baul_mediano.add_child(objeto_dupe)
		print("El objeto se borro❌📦: ",nombre)
	pass # Replace with function body.


func _on_button_5_pressed() -> void:
	if objeto_dupe:
		objeto_dupe.queue_free()
	pass # Replace with function body.


func _on_button_6_pressed() -> void:
	get_tree().quit()
	pass # Replace with function body.
