extends Area2D
class_name Hazard

@onready var timer: Timer = $Timer


func _on_body_entered(body: CharacterBody2D) -> void:
	body.die()
	if body.get_collision_layer_value(2):
		timer.start(1)


func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
