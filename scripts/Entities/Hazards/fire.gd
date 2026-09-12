extends StaticBody2D

@export var length: int = 1
@export var on_duration: float = 1.0
@export var off_duration: float = 1.0

@onready var timer: Timer = $Timer
@onready var sprite_template: AnimatedSprite2D = $AnimatedSprite2D
@onready var body_collision: CollisionShape2D = $CollisionShape2D
@onready var hazard: Area2D = $Hazard
@onready var hazard_collision: CollisionShape2D = $Hazard/CollisionShape2D

const TILE_WIDTH := 16.0
const EDGE_INSET := 3.0

var is_on := false
var sprites: Array[AnimatedSprite2D] = []


func _ready() -> void:
	_setup_length()
	_set_state()
	timer.one_shot = true
	timer.start()


func _setup_length() -> void:
	var total_width := length * TILE_WIDTH
	var offset_x = (total_width - TILE_WIDTH) / 2.0

	body_collision.shape = body_collision.shape.duplicate()
	body_collision.shape.size.x = total_width
	body_collision.position.x = offset_x

	if length > 1:
		hazard_collision.shape = hazard_collision.shape.duplicate()
		hazard_collision.shape.size.x = total_width - 2 * EDGE_INSET
		hazard_collision.position.x = offset_x
	sprites = [sprite_template]
	for i in range(1, length):
		var sprite = sprite_template.duplicate()
		sprite.position.x = sprite_template.position.x + i * TILE_WIDTH
		add_child(sprite)
		sprites.append(sprite)


func _set_state() -> void:
	hazard.set_deferred(&"monitoring", is_on)
	for sprite in sprites:
		sprite.play(&"on" if is_on else &"off")
	timer.start(on_duration if is_on else off_duration)


func _on_timer_timeout() -> void:
	is_on = not is_on
	_set_state()
