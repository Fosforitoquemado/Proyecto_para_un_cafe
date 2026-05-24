class_name UIState
extends Node

# Referencia al controlador principal (se asignará automáticamente)
var fsm: Node

# Se ejecuta al entrar al estado (ej. mostrar un panel, activar botones)
func enter() -> void:
	pass

# Se ejecuta al salir del estado (ej. ocultar un panel)
func exit() -> void:
	pass

# Para manejar inputs específicos de este estado
func handle_input(_event: InputEvent) -> void:
	pass
