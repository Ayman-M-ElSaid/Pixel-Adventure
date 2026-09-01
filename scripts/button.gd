extends TextureButton


var original_position: Vector2

func _ready():
	original_position = position
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _on_mouse_entered():
	var tween = create_tween()
	tween.tween_property(self, "position:y", original_position.y - 3, 0.1)
	tween.parallel().tween_property(self, "modulate", Color.GRAY, 0.1)


func _on_mouse_exited():
	var tween = create_tween()
	tween.tween_property(self, "position:y", original_position.y, 0.1)
	tween.parallel().tween_property(self, "modulate", Color.WHITE, 0.1)
