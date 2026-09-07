extends Area2D
class_name Hazard

@onready var timer = $Timer


func _on_body_entered(body) -> void:
	body.die()
	timer.start(1)


func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
