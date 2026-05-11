extends Button

@onready var sub_viewport_container: SubViewportContainer = $"../SubViewportContainer"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	if SaveLoad.contents_to_save.values()[1] >= 2000.0:
		SaveLoad.contents_to_save["dinero"] = snapped(SaveLoad.contents_to_save.values()[1] - 2000.0, 0.01)
		SaveLoad._save()
		sub_viewport_container.star()
	pass # Replace with function body.
