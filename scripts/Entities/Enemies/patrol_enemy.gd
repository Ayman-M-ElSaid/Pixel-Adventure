extends Enemy
class_name PatrolEnemy

@export var speed := 100.0

@onready var wall_check: RayCast2D = $WallCheck
@onready var ledge_check: RayCast2D = $LedgeCheck
@onready var pause_timer: Timer = $PauseTimer

var _direction := -1.0
var _has_stopped := false


func _physics_process(delta: float) -> void:
	if not is_dead:
		if _has_stopped:
			velocity.x = 0
			return

		if wall_check.is_colliding() or not ledge_check.is_colliding():
			_change_direction()

	velocity.x = _direction * speed
	super._physics_process(delta)


func _change_direction() -> void:
	if _has_stopped:
		return

	_has_stopped = true
	_direction *= -1
	wall_check.target_position.x *= -1
	ledge_check.position.x *= -1
	animated_sprite.play(&"idle")
	randomize()
	pause_timer.start(randf_range(0.8, 1.2))


func _on_pause_timer_timeout() -> void:
	_has_stopped = false
	animated_sprite.play(&"run")
	animated_sprite.flip_h = _direction > 0
