extends StaticBody2D

@export var on_duration: float = 1.0
@export var off_duration: float = 1.0

@onready var timer = $Timer
@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape = $Hazard/CollisionShape2D
@onready var hazard = $Hazard

var is_on := false


func _set_state() -> void:
	hazard.monitoring = is_on
	animated_sprite.play("on" if is_on else "off")
	timer.start(on_duration if is_on else off_duration)


func _ready() -> void:
	_set_state()
	timer.start()


func _on_timer_timeout() -> void:
	is_on = not is_on
	_set_state()
