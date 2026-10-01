extends TouchScreenButton

@export var pressed_tint := Color(0.7, 0.7, 0.7, 0.7)


func _ready() -> void:
	var released_tint = modulate
	pressed.connect(
		func():
			modulate = pressed_tint,
	)
	released.connect(
		func():
			modulate = released_tint,
	)
