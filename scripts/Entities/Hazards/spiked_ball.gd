extends Node2D

@export_range(-90, 90) var swing_angle_degrees: float = 45.0
@export var swing_duration: float = 1.0
@export var chain_length: int = 6

@onready var chain: Sprite2D = $Chain
@onready var spiked_ball: Sprite2D = $SpikedBall

const CHAIN_SIZE = 8


func _ready() -> void:
	_set_size()
	_set_tween()


func _set_size() -> void:
	chain.region_rect = Rect2i(0, 0, CHAIN_SIZE, CHAIN_SIZE * chain_length)
	spiked_ball.position.y = CHAIN_SIZE * chain_length + 12


func _set_tween() -> void:
	rotation_degrees = swing_angle_degrees
	var tween := create_tween()
	tween.set_loops(0)
	tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "rotation_degrees", -swing_angle_degrees, swing_duration)
	tween.tween_property(self, "rotation_degrees", swing_angle_degrees, swing_duration)
