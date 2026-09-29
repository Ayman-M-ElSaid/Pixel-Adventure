extends CanvasLayer

signal tutorial_finished

@onready var highlight: Panel = %Highlight
@onready var dialog_label: Label = %DialogLabel

var steps: Array = []
var current_step := -1
var active := false


func start(step_list: Array) -> void:
	if step_list.is_empty():
		return
	steps = step_list
	current_step = -1
	active = true
	show()
	_advance()


func _unhandled_input(event: InputEvent) -> void:
	if active and event.is_action_pressed(&"ui_accept"):
		get_viewport().set_input_as_handled()
		_advance()


func _on_dim_rect_gui_input(event: InputEvent) -> void:
	if active and event is InputEventMouseButton and event.pressed:
		_advance()


func _advance() -> void:
	current_step += 1
	if current_step >= steps.size():
		_finish()
		return

	var step: Dictionary = steps[current_step]
	var world_rect: Rect2 = step.target.get_global_rect()
	var canvas: Transform2D = get_viewport().canvas_transform
	var rect := Rect2(canvas * world_rect.position, canvas.basis_xform(world_rect.size)).grow(6)
	highlight.global_position = rect.position
	highlight.size = rect.size
	dialog_label.text = step.text.to_upper()


func _finish() -> void:
	active = false
	hide()
	tutorial_finished.emit()
