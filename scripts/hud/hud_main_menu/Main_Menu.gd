extends Control

@export var label_dia: Label
@export var label_dinero: Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	var savedata = SaveLoad.contents_to_save
	label_dia.text = str("DIA: ",savedata.values()[0] + 1)
	label_dinero.text = str("DINERO: ",savedata.values()[1])
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
