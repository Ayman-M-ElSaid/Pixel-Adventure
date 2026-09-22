extends Area2D

@export var bounce_force := 500.0

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	animated_sprite.play("idle")


func _on_body_entered(body: Player) -> void:
	body.bounce(bounce_force)
	set_deferred(&"monitoring", false)
	animated_sprite.play(&"jump")
	await animated_sprite.animation_finished
	animated_sprite.play(&"idle")
	set_deferred(&"monitoring", true)
