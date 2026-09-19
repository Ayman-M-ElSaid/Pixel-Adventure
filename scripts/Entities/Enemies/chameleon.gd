extends ChaseEnemy

@onready var tongue_hazard: Area2D = $TongueHazard
@onready var tongue_hazard_collision: CollisionShape2D = $TongueHazard/CollisionShape2D
@onready var ledge_check: RayCast2D = $LedgeCheck

const BODY_OFFSET := 20.0
const ATTACK_RANGE := 60.0
const HIT_FRAME := 6
const ATTACK_COOLDOWN := 0.35

var _is_attacking := false
var _attack_cooldown := 0.0


func _ready() -> void:
	super._ready()
	_face(direction == Direction.RIGHT)


func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	_attack_cooldown = maxf(_attack_cooldown - delta, 0.0)


func _chase() -> void:
	if _is_attacking:
		return

	var dx := _target.global_position.x - global_position.x

	if absf(dx) > FACING_DEADZONE:
		_face(dx > 0)

	if absf(dx) <= ATTACK_RANGE:
		velocity.x = 0.0
		if _attack_cooldown <= 0.0:
			_attack()
		else:
			animated_sprite.play(&"idle")
		return

	ledge_check.force_raycast_update()
	if ledge_check.is_colliding():
		velocity.x = signf(dx) * speed
		animated_sprite.play(&"run")
	else:
		velocity.x = 0.0
		animated_sprite.play(&"idle")


func _face(right: bool) -> void:
	animated_sprite.flip_h = right
	animated_sprite.offset.x = BODY_OFFSET if right else -BODY_OFFSET
	ledge_check.position.x = 10.0 if right else -10.0


func _attack() -> void:
	_is_attacking = true
	velocity.x = 0.0
	tongue_hazard_collision.position.x = absf(tongue_hazard_collision.position.x) * (
		1 if animated_sprite.flip_h else -1
	)
	animated_sprite.play(&"attack")
	await animated_sprite.animation_finished
	tongue_hazard.set_deferred(&"monitoring", false)
	if is_dead:
		return
	_is_attacking = false
	_attack_cooldown = ATTACK_COOLDOWN
	animated_sprite.play(&"idle")


func _on_frame_changed() -> void:
	if animated_sprite.animation == &"attack" and animated_sprite.frame == HIT_FRAME:
		tongue_hazard.set_deferred(&"monitoring", true)


func _go_idle() -> void:
	if _is_attacking:
		return
	super._go_idle()
