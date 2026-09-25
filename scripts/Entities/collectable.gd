extends Area2D
class_name Collectable

signal collected(name: Fruit)
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
	Fruit.APPLE: preload("res://resources/Fruits/Apple.tres"),
	Fruit.BANANAS: preload("res://resources/Fruits/Bananas.tres"),
	Fruit.CHERRIES: preload("res://resources/Fruits/Cherries.tres"),
	Fruit.KIWI: preload("res://resources/Fruits/Kiwi.tres"),
	Fruit.MELON: preload("res://resources/Fruits/Melon.tres"),
	Fruit.ORANGE: preload("res://resources/Fruits/Orange.tres"),
	Fruit.PINEAPPLE: preload("res://resources/Fruits/Pineapple.tres"),
	Fruit.STRAWBERRY: preload("res://resources/Fruits/Strawberry.tres"),
}
@export var fruit_name: Fruit = Fruit.RANDOM

@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var collect_effect: AnimatedSprite2D = $CollectEffect
@onready var collect_sound: AudioStreamPlayer2D = $CollectSound


func _ready() -> void:
	if fruit_name == Fruit.RANDOM:
		var weights = PackedFloat32Array([2, 2, 2, 1, 2, 2, 2, 2, 0])
		fruit_name = Fruit.values()[RandomNumberGenerator.new().rand_weighted(weights)]

	animated_sprite.sprite_frames = FRAMES[fruit_name]
	animated_sprite.play(&"fruit")
	collect_effect.hide()


func _on_body_entered(_body) -> void:
	collected.emit(fruit_name as Fruit)
	collision.set_deferred(&"disabled", true)
	animated_sprite.hide()
	collect_sound.play()
	collect_effect.show()
	collect_effect.play(&"collect")
	await collect_effect.animation_finished
	queue_free()
