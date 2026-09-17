extends Enemy
class_name PatrolEnemy

@export var speed := 100.0
@export var flying := false
@export var patrol_distance: float

@onready var wall_check: RayCast2D = $WallCheck
@onready var ledge_check: RayCast2D = $LedgeCheck
@onready var pause_timer: Timer = $PauseTimer

var _base_position: Vector2
var _has_stopped := false
var _idle_animation := &"idle"
var _move_animation = &"run"


func _ready():
	_base_position = position
	if flying:
		ledge_check.set_deferred(&"enabled", false)
	if direction == Direction.RIGHT:
		animated_sprite.flip_h = true
		wall_check.target_position.x *= -1
		ledge_check.position.x *= -1
	animated_sprite.play(_move_animation)


func _physics_process(delta: float) -> void:
	super._physics_process(delta)

	if is_dead:
		return

	if _has_stopped:
		velocity.x = 0
		return

	if patrol_distance:
		if absf(position.x - _base_position.x) >= patrol_distance or wall_check.is_colliding():
			_change_direction()
	elif wall_check.is_colliding() or (not flying and not ledge_check.is_colliding()):
		_change_direction()

	velocity.x = direction * speed


func _change_direction() -> void:
	if _has_stopped:
		return

	_has_stopped = true
	direction = (direction * -1) as Direction
	wall_check.target_position.x *= -1
	ledge_check.position.x *= -1
	animated_sprite.play(_idle_animation)
	randomize()
	pause_timer.start(randf_range(0.8, 1.2))


func _on_pause_timer_timeout() -> void:
	_has_stopped = false
	animated_sprite.play(_move_animation)
	animated_sprite.flip_h = direction == Direction.RIGHT
