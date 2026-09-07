extends AnimatableBody2D

@export var points: PackedVector2Array = []
@export var duration: float = 2.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hazard: Area2D = $Hazard

const BLOCK_SIZE := 32.0


func _ready() -> void:
	var _start_position: Vector2 = position
	animated_sprite.animation_finished.connect(_on_hit_animation_finished)
	hazard.monitoring = false

	if points.size() <= 0:
		return
	var move_points: Array[Vector2] = [_start_position]
	for point in points:
		move_points.append(point)
	move_points.append(_start_position)

	var total_length := 0.0
	var previous_point := _start_position
	for point in move_points.slice(1):
		total_length += previous_point.distance_to(point)
		previous_point = point
	if total_length <= 0.0:
		return

	var _tween: Tween = create_tween()
	_tween.set_loops(0)

	previous_point = _start_position
	for point in move_points.slice(1):
		var segment_vector: Vector2 = point - previous_point
		var segment_length := previous_point.distance_to(point)
		var segment_time := duration * (segment_length / total_length)

		var squish_position: Vector2 = point - segment_vector.normalized() * BLOCK_SIZE
		var squish_time := segment_time * ((segment_length - BLOCK_SIZE) / segment_length)
		_tween.tween_property(self, "position", squish_position, squish_time)
		_tween.tween_callback(
			func():
				hazard.monitoring = true,
		)
		_tween.tween_property(self, "position", point, segment_time - squish_time)
		_tween.tween_callback(_play_hit_animation.bind(segment_vector))
		previous_point = point


func _play_hit_animation(direction: Vector2) -> void:
	if abs(direction.x) > abs(direction.y):
		animated_sprite.play(&"horizontal_hit")
	else:
		animated_sprite.play(&"vertical_hit")


func _on_hit_animation_finished() -> void:
	hazard.monitoring = false
	animated_sprite.play(&"idle")
