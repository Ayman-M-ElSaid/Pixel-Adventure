extends Area2D
class_name Hazard

@onready var timer: Timer = $Timer


func _on_body_entered(body: CharacterBody2D) -> void:
	body.die()
	if is_instance_of(body, Player):
		timer.start(1)


func _on_timer_timeout() -> void:
	if Transition.is_busy():
		return
	get_tree().reload_current_scene()
