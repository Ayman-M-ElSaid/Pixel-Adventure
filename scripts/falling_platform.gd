extends AnimatableBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D
@onready var trigger_zone = $TriggerZone
@onready var timer = $Timer

var _tween: Tween
var _triggered := false


func _ready():
	animated_sprite.play("on")


func _on_trigger_zone_body_entered(_body: CharacterBody2D):
	if _triggered:
		return
	_triggered = true
	set_deferred("trigger_zone:monitoring", false)
	_shake()
	timer.start()


func _shake() -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween().set_loops(2)
	_tween.tween_property(self, "position:x", position.x + 3, 0.05)
	_tween.tween_property(self, "position:x", position.x - 3, 0.05)


func _on_timer_timeout():
	animated_sprite.play("off")
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.set_ease(Tween.EASE_IN)
	_tween.tween_property(self, "position:y", 320, .5)
	_tween.tween_callback(queue_free)
