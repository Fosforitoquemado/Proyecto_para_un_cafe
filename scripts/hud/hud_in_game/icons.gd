extends TextureRect

@export var panel:PanelContainer

var boton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boton = find_child("boton_icono")
	pass # Replace with function body.

func _on_boton_icono_pressed() -> void:
	panel.show()
	pass # Replace with function body.
