extends UIState

@export var page: Control

func enter() -> void:
	if fsm.debug:
		print("ENTER ", name)
	page.show()

func exit() -> void:
	if fsm.debug:
		print("EXIT ", name)
	page.hide()
