extends StaticBody2D

@export var height: float = 100
@export var on_duration: float = 2.0
@export var off_duration: float = 2.0
@export var decel_zone: float = 20.0

@onready var lift_area: Area2D = $LiftArea
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $LiftArea/CollisionShape2D
@onready var particles: CPUParticles2D = $CPUParticles2D
@onready var timer: Timer = $Timer

const ACCELERATION: float = 1200.0
const MAX_SPEED: float = 400.0

var is_on := false
var player_inside: Player = null
var top_edge: float
var bob_timer := 0.0


func _ready() -> void:
	const SPRITE_HEIGHT = 8
	var lift_area_size = Vector2(23, height)
	var lift_area_position = Vector2(0, (-height + SPRITE_HEIGHT) / 2)
	collision_shape.position = lift_area_position
	collision_shape.shape.size = lift_area_size
	particles.position = lift_area_position
	particles.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	particles.emission_rect_extents = lift_area_size / 2
	top_edge = lift_area_position.y - lift_area_size.y / 2

	timer.one_shot = true
	_set_state()


func _set_state() -> void:
	animated_sprite.play(&"on" if is_on else &"off")
	lift_area.set_deferred(&"monitoring", is_on)
	particles.emitting = is_on
	timer.start(on_duration if is_on else off_duration)


func _on_timer_timeout() -> void:
	is_on = not is_on
	_set_state()


func _on_lift_area_body_entered(body: Player) -> void:
	player_inside = body


func _on_lift_area_body_exited(_body: Player) -> void:
	player_inside = null


func _physics_process(delta: float) -> void:
	bob_timer += delta

	if player_inside and is_on:
		const BOB_AMPLITUDE: float = 6.0
		const BOB_FREQUENCY: float = 1.5
		const HOVER_GAIN: float = 10.0
		var local_y = to_local(player_inside.global_position).y
		var distance_to_top = local_y - top_edge
		if distance_to_top < decel_zone:
			var equilibrium_y = top_edge + decel_zone * 0.5
			var bob_target_y = equilibrium_y + sin(bob_timer * BOB_FREQUENCY * TAU) * BOB_AMPLITUDE
			var target_velocity = clamp(
				(bob_target_y - local_y) * HOVER_GAIN,
				-MAX_SPEED,
				MAX_SPEED,
			)
			player_inside.velocity.y = move_toward(
				player_inside.velocity.y,
				target_velocity,
				ACCELERATION * delta,
			)
		else:
			player_inside.velocity.y = move_toward(
				player_inside.velocity.y,
				-MAX_SPEED,
				ACCELERATION * delta,
			)
