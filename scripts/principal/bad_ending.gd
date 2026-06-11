extends Node

@export var HUD:Control
@export var game_over:Control
@export var animationplayer:AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var pantalla_negra = HUD.find_child("pantalla_negro")
	pantalla_negra.aclarar(3)
	await get_tree().create_timer(3,false).timeout
	animationplayer.play("new_animation")
	await get_tree().create_timer(2.5,false).timeout
	game_over.visible = true
	var tween = create_tween()
	tween.tween_property(game_over,"modulate",Color(1.0, 1.0, 1.0, 1.0),2.0)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
