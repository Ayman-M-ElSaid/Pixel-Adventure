extends PatrolEnemy

@export var enraged_speed := 250.0


func _on_stomp(remaining: int) -> void:
	if remaining > 0:
		pause_timer.timeout.emit()
		pause_timer.stop()
		pause_timer.queue_free()
		speed = enraged_speed
		animated_sprite.play(&"hit")
		animated_sprite.animation_finished.connect(
			func():
				animated_sprite.play(&"run_2"),
		)


func _change_direction() -> void:
	if hit_points == 2:
		super._change_direction()
	else:
		_direction *= -1
		wall_check.target_position.x *= -1
		ledge_check.position.x *= -1
		animated_sprite.flip_h = _direction > 0


func die() -> void:
	if is_dead:
		return
	is_dead = true
	hazard.monitoring = false
	animated_sprite.play(&"hit_2")
	collision.queue_free()
	died.emit()
