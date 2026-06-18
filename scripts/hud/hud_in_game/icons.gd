extends TextureRect

@export var panel:PanelContainer
@onready var pc_control: Control = $"../.."
@onready var max_ram: Control = $"../MAX_RAM"

var boton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boton = find_child("boton_icono")
	pass # Replace with function body.

func _on_boton_icono_pressed() -> void:
	if pc_control.ventanas.size() < GameManager.max_ventanas and name not in pc_control.ventanas:
		pc_control.agregar_icono(self,name)
		panel.show()
	else:
		AudioManager.play_pc_error()
		max_ram.show()
		max_ram.modulate = Color(1.0, 1.0, 1.0, 1.0)
		var tween = create_tween()
		tween.tween_property(max_ram,"modulate",Color(1.0, 1.0, 1.0, 0.0),1)
		await get_tree().create_timer(1).timeout
		max_ram.hide()
		
	pass # Replace with function body.
