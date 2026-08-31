extends Area2D

@export var height: float = 300
@export var on_duration: float = 1.0
@export var off_duration: float = 1.0

@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D
@onready var timer = $Timer

var is_on := false
var player_inside: CharacterBody2D = null


func _ready() -> void:
	const SPRITE_HEIGHT = 8
	collision_shape.position = Vector2(0, (-height + SPRITE_HEIGHT) / 2)
	collision_shape.shape.size = Vector2(23, height)
	_set_state()
	timer.start()


func _set_state() -> void:
	animated_sprite.play("on" if is_on else "off")
	timer.wait_time = on_duration if is_on else off_duration
	set_deferred("monitoring", is_on)



func _on_timer_timeout() -> void:
	is_on = not is_on
	_set_state()


func _physics_process(delta: float) -> void:
	if player_inside:
		player_inside.velocity.y -= 1200 * delta


func _on_body_entered(body: CharacterBody2D) -> void:
	player_inside = body


func _on_body_exited(_body: CharacterBody2D) -> void:
	player_inside = null
