extends Area2D
class_name Collectable

signal collected
enum Fruit {
	APPLE,
	BANANAS,
	CHERRIES,
	KIWI,
	MELON,
	ORANGE,
	PINEAPPLE,
	STRAWBERRY,
	RANDOM,
}
const FRAMES: Dictionary = {
	Fruit.APPLE: preload("res://assets/Items/Fruits/Apple.tres"),
	Fruit.BANANAS: preload("res://assets/Items/Fruits/Bananas.tres"),
	Fruit.CHERRIES: preload("res://assets/Items/Fruits/Cherries.tres"),
	Fruit.KIWI: preload("res://assets/Items/Fruits/Kiwi.tres"),
	Fruit.MELON: preload("res://assets/Items/Fruits/Melon.tres"),
	Fruit.ORANGE: preload("res://assets/Items/Fruits/Orange.tres"),
	Fruit.PINEAPPLE: preload("res://assets/Items/Fruits/Pineapple.tres"),
	Fruit.STRAWBERRY: preload("res://assets/Items/Fruits/Strawberry.tres"),
}
@export var fruit_name: Fruit = Fruit.RANDOM

@onready var collision = $CollisionShape2D
@onready var animated_sprite = $AnimatedSprite
@onready var collect_effect = $CollectEffect
@onready var collect_sound = $CollectSound


func _ready() -> void:
	if fruit_name != Fruit.RANDOM:
		animated_sprite.sprite_frames = FRAMES[fruit_name]
	else:
		var weights = PackedFloat32Array([2.5, 2.5, 2.5, 1, 2.5, 2.5, 2.5, 2.5, 0])
		var fruit: Fruit = Fruit.values()[RandomNumberGenerator.new().rand_weighted(weights)]
		animated_sprite.sprite_frames = FRAMES[fruit]
	animated_sprite.play(&"fruit")
	collect_effect.hide()


func _on_body_entered(_body) -> void:
	collected.emit()
	collision.set_deferred(&"disabled", true)
	animated_sprite.hide()
	collect_sound.play()
	collect_effect.show()
	collect_effect.play(&"collect")
	await collect_effect.animation_finished
	queue_free()
