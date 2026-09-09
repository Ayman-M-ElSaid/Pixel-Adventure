extends Hazard

enum Direction {
	UP,
	DOWN,
	LEFT,
	RIGHT,
}

@export var trigger_direction: Direction = Direction.DOWN
@export var fall_distance: float = 100.0
@export var fall_time: float = 0.3
@export var retraction := true

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var trigger_ray: RayCast2D = $TriggerRay

var _triggered := false
var _direction: Vector2


func _get_direction(dir: Direction) -> Vector2:
	match dir:
		Direction.UP:
			return Vector2.UP
		Direction.DOWN:
			return Vector2.DOWN
		Direction.LEFT:
			return Vector2.LEFT
		Direction.RIGHT:
			return Vector2.RIGHT
	return Vector2.DOWN


func _ready() -> void:
	_direction = _get_direction(trigger_direction)
	trigger_ray.target_position = _direction * fall_distance
	trigger_ray.enabled = true
	animated_sprite.animation_finished.connect(_on_hit_animation_finished)


func _physics_process(_delta: float) -> void:
	if _triggered:
		return
	if trigger_ray.is_colliding():
		_triggered = true
		_fall()


func _fall() -> void:
	var target := position + _direction * fall_distance
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	tween.tween_property(self, "position", target, fall_time)
	tween.tween_callback(_play_hit_animation)


func _play_hit_animation() -> void:
	if abs(_direction.x) > abs(_direction.y):
		animated_sprite.play(&"horizontal_hit")
		animated_sprite.flip_h = _direction.x < 0
	else:
		animated_sprite.play(&"vertical_hit")


func _on_hit_animation_finished() -> void:
	animated_sprite.play(&"idle")
	_retract()


func _retract() -> void:
	var target := position - _direction * fall_distance
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "position", target, fall_time * 3)
	tween.tween_callback(
		func():
			_triggered = false,
	)
