extends Area2D

signal collected

@onready var collision = $CollisionShape2D
@onready var sprite = $Sprite
@onready var collect_sound = $CollectSound
@onready var collect_effect = $CollectEffect


func _on_body_entered(_body):
	collected.emit()
	collision.set_deferred("disabled", true)
	sprite.hide()
	collect_effect.show()
	collect_effect.play("collect")
	collect_sound.play()
	await collect_effect.animation_finished
	queue_free()
