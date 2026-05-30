extends Button

@onready var label_dia: Label = $"../Label_dia"
@onready var label_dinero: Label = $"../Label_dinero"


func _on_pressed() -> void:
	SaveLoad.contents_to_save["dinero"] = 0
	SaveLoad.contents_to_save["day"] = 0
	SaveLoad.contents_to_save["tutorial_yes_no"] = false
	SaveLoad.contents_to_save["tutorial_inspeccion"] = false
	SaveLoad.contents_to_save["tutorial_pc"] = false
	SaveLoad.contents_to_save["tutorial_baul"] = false
	SaveLoad.contents_to_save["usos_mate"] = 3
	SaveLoad._save()
	
	label_dia.text = str("DIA: ",1)
	label_dinero.text = str("DINERO: ",0)
	pass # Replace with function body.
