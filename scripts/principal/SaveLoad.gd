extends Node

const  save_location = "user://SaveFile.json"

var contents_to_save: Dictionary = {
	"day": 0,
	"dinero": 0.0,
	"new_data_to_save": false
}

func _ready() -> void:
	_load()

func _save():
	var file = FileAccess.open(save_location, FileAccess.WRITE)
	file.store_var(contents_to_save.duplicate())
	file.close()
	
func _load():
	if FileAccess.file_exists(save_location):
		var file = FileAccess.open(save_location, FileAccess.READ)
		var data = file.get_var()
		file.close()
		
		var save_data = data.duplicate()
		contents_to_save["day"] = save_data["day"]
		contents_to_save["dinero"] = save_data["dinero"]
		contents_to_save["new_data_to_save"] = save_data["new_data_to_save"]
		return save_data
