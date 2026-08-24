extends Node

@onready var tilemap = %TileMap
@onready var camera = %Camera
@onready var collectables = %Collectables
var remaining_collectables


func get_level_dimensions():
	var used_rect = tilemap.get_used_rect()
	var cell_size = Vector2(tilemap.tile_set.tile_size)
	var topleft = Vector2(used_rect.position) * cell_size
	var level_size: Vector2 = Vector2(used_rect.size) * cell_size
	return { "topleft": topleft, "level_size": level_size }


func _set_camera_limits():
	var level_dimensions = get_level_dimensions()
	var top_left = level_dimensions["topleft"]
	var bottom_right = level_dimensions["topleft"] + level_dimensions["level_size"]

	camera.limit_left = int(top_left.x)
	camera.limit_top = int(top_left.y)
	camera.limit_right = int(bottom_right.x)
	camera.limit_bottom = int(bottom_right.y)


func _ready() -> void:
	_set_camera_limits()
	remaining_collectables = collectables.get_child_count()
	for item in collectables.get_children():
		item.collected.connect(_on_item_collected)


func _on_item_collected() -> void:
	remaining_collectables -= 1
	if remaining_collectables == 0:
		print("All collectables gathered — level complete!")
