extends TextureButton

var original_position: Vector2


func _ready() -> void:
	original_position = position
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _on_mouse_entered() -> void:
	var tween = create_tween().set_parallel()
	tween.tween_property(self, "position:y", original_position.y - 3, 0.1)
	tween.tween_property(self, "modulate", Color.GRAY, 0.1)


func _on_mouse_exited() -> void:
	var tween = create_tween().set_parallel()
	tween.tween_property(self, "position:y", original_position.y, 0.1)
	tween.tween_property(self, "modulate", Color.WHITE, 0.1)
