extends PatrolEnemy

@onready var stomp_area_collision = $StompArea/CollisionShape2D
@onready var hazard_collision: CollisionShape2D = $Hazard/CollisionShape2D

const SIZES := {
	3: {
		"size": "large",
		"body": Vector2(36, 34),
		"stomp": Vector2(38, 8),
		"stomp_y": -19.0,
		"hazard": Vector2(36, 20),
	},
	2: {
		"size": "medium",
		"body": Vector2(32, 28),
		"stomp": Vector2(32, 8),
		"stomp_y": -18.0,
		"hazard": Vector2(30, 20),
	},
	1: {
		"size": "small",
		"body": Vector2(20, 18),
		"stomp": Vector2(20, 8),
		"stomp_y": -14.0,
		"hazard": Vector2(16, 16),
	},
}

var size_data: Dictionary
var _is_splitting := false


func _ready() -> void:
	_apply_size(hit_points)
	super._ready()


func _apply_size(hp: int) -> void:
	size_data = SIZES[hp]
	_idle_animation = size_data.size + "_idle"
	_move_animation = size_data.size + "_run"
	(func():
		collision.shape = _new_rect(size_data.body)
		stomp_area_collision.shape = _new_rect(size_data.stomp)
		stomp_area_collision.position.y = size_data.stomp_y
		hazard_collision.shape = _new_rect(size_data.hazard)
	).call_deferred()


func _new_rect(size: Vector2) -> RectangleShape2D:
	var rect := RectangleShape2D.new()
	rect.size = size
	return rect


func _on_stomp(remaining: int) -> void:
	if remaining <= 0 or _is_splitting:
		return
	_is_splitting = true
	_has_stopped = true
	animated_sprite.play(size_data.size + "_hit")
	animated_sprite.animation_finished.connect(_split.bind(remaining), CONNECT_ONE_SHOT)


func _split(remaining: int) -> void:
	speed *= 1.35
	_apply_size(remaining)

	var twin := load(scene_file_path).instantiate() as PatrolEnemy
	twin.hit_points = remaining
	twin.speed = speed
	twin.patrol_distance = patrol_distance
	twin.direction = (direction * -1) as Direction
	twin.position = position
	twin.velocity.y = -100
	call_deferred(&"add_sibling", twin)
	twin._base_position = _base_position
	velocity.y = -100
	_has_stopped = false
	_is_splitting = false
	animated_sprite.play(_move_animation)
