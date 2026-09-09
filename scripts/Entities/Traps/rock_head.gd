extends AnimatableBody2D

@export var points: PackedVector2Array = []
@export var duration: float = 2.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var hazard: Area2D = $Hazard
@onready var hazard_collision = $Hazard/CollisionShape2D

const BLOCK_SIZE := 32.0

var _tween: Tween


func _ready() -> void:
	var _start_position: Vector2 = position
	animated_sprite.animation_finished.connect(_on_hit_animation_finished)
	hazard.monitoring = false
	hazard_collision.shape = RectangleShape2D.new()

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

	_tween = create_tween()
	_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	_tween.set_loops(0)

	previous_point = _start_position
	for point in move_points.slice(1):
		var segment_vector: Vector2 = point - previous_point
		var segment_length := previous_point.distance_to(point)
		var segment_time := duration * (segment_length / total_length)

		var squish_position: Vector2 = point - segment_vector.normalized() * BLOCK_SIZE / 2
		var squish_time := segment_time * ((segment_length - BLOCK_SIZE / 2) / segment_length)
		_tween.tween_property(self, "position", squish_position, squish_time)
		_tween.tween_callback(_activate_hazard.bind(segment_vector))
		_tween.tween_property(self, "position", point, segment_time - squish_time)
		_tween.tween_callback(_play_hit_animation.bind(segment_vector))
		previous_point = point


func _activate_hazard(direction: Vector2) -> void:
	hazard.monitoring = true
	if abs(direction.x) > abs(direction.y):
		hazard_collision.shape.size = Vector2(16, 32)
		hazard.position = Vector2(-24, 0) if direction.x < 0 else Vector2(24, 0)
	else:
		hazard_collision.shape.size = Vector2(32, 16)
		hazard.position = Vector2(0, -24) if direction.y < 0 else Vector2(0, 24)


func _play_hit_animation(direction: Vector2) -> void:
	_tween.pause()
	if abs(direction.x) > abs(direction.y):
		animated_sprite.play(&"horizontal_hit")
		animated_sprite.flip_h = direction.x < 0
	else:
		animated_sprite.play(&"vertical_hit")


func _on_hit_animation_finished() -> void:
	hazard.monitoring = false
	animated_sprite.play(&"idle")
	_tween.play()
