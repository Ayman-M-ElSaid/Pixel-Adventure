extends Enemy

@export var charge_distance: float = 100.0
@export var max_speed: float = 250.0
@export var acceleration: float = 500.0
@export var recoil_speed: float = 100.0
@export var windup_time: float = 0.5
@export var stun_time: float = 1.0
@export var recoil_hop: float = 150.0

@onready var line_of_sight: RayCast2D = $LineOfSight

enum State {
	IDLE,
	WINDUP,
	CHARGE,
	STUN,
}
var _state := State.IDLE
var _state_time := 0.0


func _ready() -> void:
	_face(direction)


func _face(dir: Direction) -> void:
	direction = dir
	animated_sprite.flip_h = direction == Direction.RIGHT
	line_of_sight.target_position.x = absf(charge_distance) * direction


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	if is_dead:
		return

	match _state:
		State.IDLE:
			animated_sprite.play(&"idle")
			velocity.x = 0.0
			if is_instance_of(line_of_sight.get_collider(), Player):
				_change_state(State.WINDUP, windup_time)
		State.WINDUP:
			_state_time -= delta
			if _state_time <= 0.0:
				_change_state(State.CHARGE)
		State.CHARGE:
			animated_sprite.play(&"run")
			velocity.x = move_toward(velocity.x, direction * max_speed, acceleration * delta)
			if is_on_wall():
				velocity = Vector2(get_wall_normal().x * recoil_speed, -recoil_hop)
				animated_sprite.play(&"wall_hit")
				_change_state(State.STUN, stun_time)
		State.STUN:
			animated_sprite.play(&"idle")
			if is_on_floor():
				velocity.x = move_toward(velocity.x, 0.0, 400.0 * delta)
			_state_time -= delta
			if _state_time <= 0.0:
				_face(-direction)
				_change_state(State.IDLE)


func _change_state(new_state: State, time := 0.0) -> void:
	_state = new_state
	_state_time = time
