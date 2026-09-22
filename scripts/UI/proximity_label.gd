@tool
extends Area2D

@export var trigger_radius: float = 80:
	set(value):
		trigger_radius = value
		if trigger_area:
			trigger_area.shape.radius = value

@export var text: String:
	set(value):
		text = value
		if label:
			label.text = value

@export var label_size: Vector2 = Vector2(80, 40):
	set(value):
		label_size = value
		if label:
			label.size = value
			label.position = -value * 0.5

@onready var trigger_area: CollisionShape2D = $TriggerArea
@onready var label: Label = $Label

const fade_duration: float = 0.5
var _tween: Tween


func _ready():
	trigger_area.shape.radius = trigger_radius
	label.text = text
	label.size = label_size
	label.position = -label_size * 0.5
	if not Engine.is_editor_hint():
		label.modulate.a = 0.0


func _on_body_entered(_body: Player):
	_set_alpha(1.0)


func _on_body_exited(_body: Player):
	_set_alpha(0.0)


func _set_alpha(alpha: float):
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(label, "modulate:a", alpha, fade_duration)
