extends Area2D
class_name Collectable
signal collected

enum Fruit {
	APPLE,
	BANANA,
	CHERRY,
	KIWI,
	MELON,
	ORANGE,
	PINEAPPLE,
	STRAWBERRY,
}
@export var fruit_name: Fruit
@export var sprite_frames: SpriteFrames

@onready var collision = $CollisionShape2D
@onready var animated_sprite = $AnimatedSprite
@onready var collect_effect = $CollectEffect
@onready var collect_sound = $CollectSound


func _ready() -> void:
	if sprite_frames:
		animated_sprite.sprite_frames = sprite_frames
	animated_sprite.play("fruit")
	collect_effect.hide()


func _on_body_entered(_body):
	collected.emit()
	collision.set_deferred("disabled", true)
	animated_sprite.hide()
	collect_sound.play()
	collect_effect.show()
	collect_effect.play("collect")
	await collect_effect.animation_finished
	queue_free()
