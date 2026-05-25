extends Node

const  save_location = "user://SaveFile.json"

var contents_to_save: Dictionary = {
	"day": 0,
	"dinero": 0.0,
	"tutorial_yes_no": false,
	"tutorial_inspeccion": false,
	"tutorial_baul": false,
	"tutorial_pc": false,
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
		if data is Dictionary:
			# Loop through your current default dictionary keys
			for key in contents_to_save.keys():
				# Only overwrite if the save file actually contains the key
				if data.has(key):
					contents_to_save[key] = data[key]
		return contents_to_save
