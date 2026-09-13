extends Enemy
class_name ChaseEnemy

@export var speed := 100.0
@export var trigger_area: Shape2D
@export var flying := false

@onready var trigger_area_node: Area2D = $TriggerArea
@onready var trigger_area_collision: CollisionShape2D = $TriggerArea/CollisionShape2D
@onready var line_of_sight: RayCast2D = $LineOfSight

const FACING_DEADZONE := 4

var _target: CharacterBody2D = null
var _is_chasing := false


func _ready() -> void:
	animated_sprite.flip_h = direction == Direction.RIGHT
	trigger_area_collision.shape = trigger_area
	animated_sprite.play(&"idle")


func _physics_process(delta: float) -> void:
	if not is_dead and _target:
		if _has_line_of_sight() and not _is_chasing:
			_wake_up()
		elif not _has_line_of_sight() and _is_chasing:
			_go_idle()
		if _is_chasing:
			_chase()

	super._physics_process(delta)


func _chase() -> void:
	var target_vector := _target.global_position - global_position
	if flying:
		velocity = target_vector.normalized() * speed
		if absf(target_vector.x) > FACING_DEADZONE:
			animated_sprite.flip_h = target_vector.x > 0
	else:
		if absf(target_vector.x) > FACING_DEADZONE:
			velocity.x = signf(target_vector.x) * speed
			animated_sprite.flip_h = velocity.x > 0
		else:
			velocity.x = 0


func _has_line_of_sight() -> bool:
	line_of_sight.target_position = to_local(_target.global_position)
	line_of_sight.force_raycast_update()
	return not line_of_sight.is_colliding()


func _wake_up() -> void:
	if flying:
		animated_sprite.play(&"wake_up")
		animated_sprite.animation_finished.connect(
			func():
				animated_sprite.play("fly")
				_is_chasing = true,
			CONNECT_ONE_SHOT,
		)
	else:
		_is_chasing = true
		animated_sprite.play(&"run")


func _go_idle() -> void:
	if flying:
		return
	_is_chasing = false
	velocity.x = 0
	animated_sprite.play(&"idle")


func _on_trigger_area_body_entered(body: CharacterBody2D) -> void:
	if is_dead:
		return
	_target = body


func _on_trigger_area_body_exited(_body: CharacterBody2D) -> void:
	if is_dead or flying:
		return
	_target = null
	_go_idle()


func die() -> void:
	super.die()
	trigger_area_node.set_deferred(&"monitoring", false)
	velocity.x = 0
	_is_chasing = false
