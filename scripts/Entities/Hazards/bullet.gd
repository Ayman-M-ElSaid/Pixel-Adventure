extends Hazard

@export var bullet_texture: Texture2D
@export var bullet_pieces_texture: Texture2D
@export var direction := Vector2.LEFT
@export var speed: float = 200.0

@onready var sprite = $Sprite
@onready var left_debris = $LeftDebris
@onready var right_debris = $RightDebris

var _velocity := Vector2.ZERO
const GRAVITY := 980.0


func _ready() -> void:
	sprite.texture = bullet_texture
	left_debris.sprite = bullet_pieces_texture
	right_debris.sprite = bullet_pieces_texture
	right_debris.sprite_region = Rect2(16, 0, 16, 16)
	_velocity = direction * speed


func _physics_process(delta: float) -> void:
	if direction == Vector2.DOWN:
		_velocity.y += GRAVITY * delta
		_velocity.y = min(500, _velocity.y)

	global_position += _velocity * delta

	if not is_instance_valid(right_debris):
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	if is_instance_of(body, Player):
		super._on_body_entered(body)
	else:
		sprite.set_deferred(&"visible", false)
		set_deferred(&"monitoring", false)
		left_debris.activate(Vector2(randf_range(-80, -120), randf_range(-100, -150)), 3)
		right_debris.activate(Vector2(randf_range(80, 120), randf_range(-100, -150)), 3)
