extends RigidBody2D
class_name Debris

@export var sprite: Texture2D
@export var sprite_region := Rect2(0, 0, 16, 16)
@export var fade_duration := 1.0

@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var sprite_2d: Sprite2D = $Sprite2D

var _tween: Tween


func _ready() -> void:
	visible = false
	collision.disabled = true
	freeze = true
	contact_monitor = true
	max_contacts_reported = 1
	sprite_2d.texture = sprite
	sprite_2d.region_enabled = true
	sprite_2d.region_rect = sprite_region


func activate(linear := Vector2.ZERO, angular := 0.0) -> void:
	set_deferred(&"visible", true)
	set_deferred(&"freeze", false)
	collision.set_deferred(&"disabled", false)

	linear_velocity = linear
	angular_velocity = angular


func _on_body_entered(_body: Node) -> void:
	start_fade()


func start_fade() -> void:
	if _tween:
		return
	_tween = create_tween()
	_tween.tween_property(self, "modulate:a", 0.0, fade_duration)
	_tween.tween_callback(
		func():
			queue_free(),
	)
