extends Node2D

@export var offset: Vector2
@export var duration: float
@export var automatic: bool

@onready var _body: AnimatableBody2D = $Platform
@onready var _sprite: AnimatedSprite2D = $Platform/PlatformSprite
@onready var _chain: Sprite2D = $Chain

var _start_pos: Vector2
var _triggered := false
var _moving := false
var _tween: Tween
var _pending_body: CharacterBody2D = null


func _position_chain() -> void:
	var start := _start_pos
	var end := _start_pos + offset
	var vector := end - start
	var length := vector.length()
	var tile_size := 8.0
	length = roundi(length / tile_size) * tile_size
	_chain.region_rect = Rect2(0, 0, length, tile_size)
	_chain.centered = false
	_chain.offset = Vector2(0, -tile_size / 2)
	_chain.position = start
	_chain.rotation = vector.angle()


func _ready() -> void:
	_start_pos = _body.position
	_position_chain()
	if automatic:
		start_tween()


func _physics_process(_delta: float) -> void:
	if _pending_body and is_zero_approx(_pending_body.velocity.y):
		_pending_body = null
		_triggered = true
		start_tween()


func _on_trigger_zone_body_entered(body: Node2D) -> void:
	if automatic or _triggered:
		return
	if body is CharacterBody2D:
		_pending_body = body


func _on_trigger_zone_body_exited(body: Node2D) -> void:
	if automatic:
		return
	if body == _pending_body:
		_pending_body = null
	if _triggered:
		reverse_tween()


func start_tween() -> void:
	if _tween:
		_tween.kill()
	_moving = true
	_tween = get_tree().create_tween()
	_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	_tween.set_parallel(false)
	_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_tween.tween_property(_body, "position", _start_pos + offset, duration / 2)
	await _tween.finished
	_moving = false
	if automatic:
		reverse_tween()


func reverse_tween() -> void:
	if _tween:
		_tween.kill()
	_moving = true
	_tween = get_tree().create_tween()
	_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	_tween.set_parallel(false)
	_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_tween.tween_property(_body, "position", _start_pos, duration / 2)
	await _tween.finished
	_moving = false
	if automatic:
		start_tween()
	else:
		_triggered = false


func _process(_delta: float) -> void:
	if automatic:
		_sprite.play("gray")
	elif _moving:
		_sprite.play("brown")
	else:
		_sprite.play("off")
