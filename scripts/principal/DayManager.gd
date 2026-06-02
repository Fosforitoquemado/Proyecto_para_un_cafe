extends Node

@export var dias:Array[DayResource]

var dia_actual:int = SaveLoad.contents_to_save.values()[0]

var max_dia:int = 6

func sumar_dia():
	if dia_actual < max_dia - 1:
		dia_actual += 1
	else:
		pass

func get_day() -> DayResource:
	return dias[dia_actual]
