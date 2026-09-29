extends PatrolEnemy
class_name ShootingEnemy

@export var fire_rate: float = 1
@export var detection_range := Vector2(-100, 0)
@export var requires_line_of_sight := true
@export var shoot_frame: int

@onready var bullet: Area2D = $Bullet
@onready var bullet_spawn_point: Marker2D = $BulletSpawnPoint
@onready var line_of_sight: RayCast2D = $LineOfSight
@onready var shoot_timer: Timer = $ShootTimer

var _shoot_cooldown := false


func _ready() -> void:
	super._ready()
	line_of_sight.target_position = detection_range
	if direction == Direction.RIGHT:
		line_of_sight.target_position.x *= -1
		bullet_spawn_point.position.x *= -1
		bullet.direction.x *= -1
	bullet.visible = false
	bullet.set_physics_process(false)
	bullet.monitoring = false
	if requires_line_of_sight:
		shoot_timer.one_shot = true
	else:
		shoot_timer.start(fire_rate)


func _physics_process(delta: float) -> void:
	super._physics_process(delta)

	if is_dead:
		shoot_timer.stop()
		return

	if requires_line_of_sight:
		if is_instance_of(line_of_sight.get_collider(), Player):
			_shoot()
	else:
		_shoot()
		_has_stopped = false


func _shoot() -> void:
	if _shoot_cooldown:
		return
	_shoot_cooldown = true
	_has_stopped = true
	animated_sprite.play(&"attack")
	if is_dead:
		return
	shoot_timer.start(fire_rate)
	await animated_sprite.animation_finished
	animated_sprite.play(_idle_animation)


func _on_attack_frame_changed() -> void:
	if animated_sprite.animation != &"attack":
		return
	if animated_sprite.frame == shoot_frame:
		_spawn_bullet()


func _spawn_bullet() -> void:
	var _bullet = bullet.duplicate()
	_bullet.global_position = bullet_spawn_point.global_position
	_bullet.visible = true
	_bullet.set_physics_process(true)
	_bullet.monitoring = true
	get_tree().current_scene.add_child(_bullet)


func _on_pause_timer_timeout() -> void:
	super._on_pause_timer_timeout()
	line_of_sight.target_position.x *= -1
	bullet_spawn_point.position.x *= -1
	bullet.direction.x *= -1
	bullet.sprite.flip_h = direction == Direction.RIGHT


func _on_shoot_timer_timeout() -> void:
	_shoot_cooldown = false
	_has_stopped = false
	animated_sprite.play(_move_animation)
