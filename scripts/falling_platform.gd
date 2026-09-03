extends AnimatableBody2D

@onready var animated_sprite = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D
@onready var trigger_zone = $TriggerZone
@onready var timer = $Timer

var _tween: Tween
var _triggered := false


func _ready():
	animated_sprite.play("on")


func _on_trigger_zone_body_entered(body: CharacterBody2D) -> void:
	if _triggered:
		return
	for i in 10:
		await get_tree().physics_frame
		if not trigger_zone.overlaps_body(body):
			return
		if body.is_on_floor():
			_triggered = true
			set_deferred("trigger_zone:monitoring", false)
			_shake()
			timer.start()
			return


func _shake() -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween().set_loops(2)
	_tween.tween_property(self, "position:x", position.x + 3, 0.05)
	_tween.tween_property(self, "position:x", position.x - 3, 0.05)
	var base_x = position.x
	var base_y = position.y
	_tween = create_tween()
	_tween.set_parallel(true)
	_tween.tween_method(_apply_shake_x.bind(base_x), 0.0, 0.1, 0.1)
	_tween.tween_property(self, "position:y", base_y + 3, .1) \
			.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)


func _apply_shake_x(t: float, base_x: float) -> void:
	var decay := exp(-8 * t)
	position.x = base_x + 4 * decay * sin(t * 4 * TAU)


func _on_timer_timeout():
	animated_sprite.play("off")
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(self, "position:y", 320, 0.5) \
			.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
