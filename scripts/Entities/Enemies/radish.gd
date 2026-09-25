extends PatrolEnemy

@export var radius_x := 60.0
@export var radius_y := 24.0
@export var clockwise := true

@onready var left_leaf: RigidBody2D = $LeftLeaf
@onready var right_leaf: RigidBody2D = $RightLeaf

var _direction := 1
var _theta := PI
var _is_falling := false


func _ready() -> void:
	_idle_animation = &"flying"
	_move_animation = &"flying"
	if not clockwise:
		_direction = -1
		_theta = -PI
	super._ready()


func _on_stomp(remaining: int) -> void:
	if remaining > 0:
		flying = false
		gravity = 980.0
		ledge_check.set_deferred(&"enabled", true)
		_idle_animation = &"idle"
		_move_animation = &"run"
		animated_sprite.play(&"hit")
		_is_falling = true
		left_leaf.activate(Vector2(randi_range(-30, -50), -100), randi_range(-3, -6))
		right_leaf.activate(Vector2(randi_range(30, 50), -100), randi_range(3, 6))


func _physics_process(delta: float) -> void:
	if flying:
		_theta = wrapf(_theta + delta, -PI, PI)
		position = _base_position + _direction * Vector2(
			radius_x * cos(_theta),
			radius_y * sin(_theta),
		)
		animated_sprite.flip_h = _theta < 0 if clockwise else _theta > 0
	elif _is_falling:
		velocity.y += gravity * delta
		move_and_slide()
		if is_on_floor():
			_is_falling = false
			_change_direction()
	else:
		super._physics_process(delta)
