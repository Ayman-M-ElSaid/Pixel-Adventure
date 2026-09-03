extends Camera2D

@onready var level_manager = %LevelManager

var shake_strength := 0.0
var shake_fade := 5.0


func _ready() -> void:
	# set camera limits
	var level_dimensions = level_manager.get_level_dimensions()
	var top_left = level_dimensions["topleft"]
	var bottom_right = level_dimensions["topleft"] + level_dimensions["level_size"]
	limit_left = int(top_left.x)
	limit_top = int(top_left.y)
	limit_right = int(bottom_right.x)
	limit_bottom = int(bottom_right.y)


func _process(delta) -> void:
	if shake_strength > 0:
		shake_strength = lerp(shake_strength, 0.0, shake_fade * delta)
		offset = Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength),
		)
	else:
		offset = Vector2.ZERO


func shake(amount: float) -> void:
	shake_strength = amount
