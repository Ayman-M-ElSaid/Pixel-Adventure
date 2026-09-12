extends PatrolEnemy

@export var enraged_speed := 250.0


func _on_stomp(remaining: int) -> void:
	if remaining > 0:
		pause_timer.timeout.emit()
		pause_timer.stop()
		pause_timer.queue_free()
		speed = enraged_speed
		animated_sprite.play(&"enrage")
		_move_animation = &"enraged_run"
		animated_sprite.animation_finished.connect(
			func():
				animated_sprite.play(_move_animation),
			CONNECT_ONE_SHOT,
		)


func _change_direction() -> void:
	if hit_points == 2:
		super._change_direction()
	else:
		direction = (direction * -1) as Direction
		wall_check.target_position.x *= -1
		ledge_check.position.x *= -1
		animated_sprite.flip_h = direction == Direction.RIGHT
