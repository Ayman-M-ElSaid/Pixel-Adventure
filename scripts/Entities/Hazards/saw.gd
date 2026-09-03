extends Hazard

@export var points: PackedVector2Array = []
@export var duration: float = 2.0
@export var looping: bool = false

var _start_position: Vector2
var _tween: Tween


func _ready() -> void:
	_start_position = position
	if points.size() < 0:
		return

	var move_points: Array[Vector2] = [_start_position]
	for point in points:
		move_points.append(point)
	if looping:
		move_points.append(_start_position)
	else:
		for i in range(move_points.size() - 2, -1, -1):
			move_points.append(move_points[i])

	var total_length := 0.0
	var previous_point := _start_position
	for point in move_points.slice(1):
		total_length += previous_point.distance_to(point)
		previous_point = point
	if total_length <= 0.0:
		return

	_tween = create_tween()
	_tween.set_loops(0)
	if looping:
		_tween.set_trans(Tween.TRANS_LINEAR)
	else:
		_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

	previous_point = _start_position
	for point in move_points.slice(1):
		var seg_time := duration * (previous_point.distance_to(point) / total_length)
		_tween.tween_property(self, "position", point, seg_time)
		previous_point = point
