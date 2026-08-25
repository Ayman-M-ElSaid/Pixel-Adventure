extends Node

@export var level_id: int
@onready var tilemap = %TileMap
@onready var collectables = %Collectables
var _remaining_collectables


func get_level_dimensions() -> Dictionary[String, Vector2]:
	var used_rect = tilemap.get_used_rect()
	var cell_size = Vector2(tilemap.tile_set.tile_size)
	var topleft = Vector2(used_rect.position) * cell_size
	var level_size: Vector2 = Vector2(used_rect.size) * cell_size
	return { "topleft": topleft, "level_size": level_size }


func _ready() -> void:
	_remaining_collectables = collectables.get_child_count()
	for item in collectables.get_children():
		item.collected.connect(_on_item_collected)
	Transition.play_wipe_out()


func _on_item_collected() -> void:
	_remaining_collectables -= 1
	if _remaining_collectables == 0:
		_complete_level()


func _complete_level() -> void:
	Transition.wipe_in_finished.connect(
		func():
			get_tree().change_scene_to_file("res://scenes/Levels/level_%02d.tscn" % (level_id + 1)),
		CONNECT_ONE_SHOT,
	)
	Transition.play_wipe_in()
