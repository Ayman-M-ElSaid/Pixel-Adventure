extends Node

@export var level_id: int

@onready var tilemap: TileMapLayer = %TileMap
@onready var collectables: Node2D = %Collectables
@onready var player: Player = %Player

var _remaining_collectables


func get_level_dimensions() -> Dictionary[String, Vector2]:
	var used_rect = tilemap.get_used_rect()
	var cell_size = Vector2(tilemap.tile_set.tile_size)
	var topleft = Vector2(used_rect.position) * cell_size
	var level_size: Vector2 = Vector2(used_rect.size) * cell_size
	return { "topleft": topleft, "level_size": level_size }


func _ready() -> void:
	if not PlayerManager.is_respawning:
		Transition.play_wipe_out()

	_remaining_collectables = collectables.get_child_count()
	for item in collectables.get_children():
		item.collected.connect(_on_item_collected)


func _on_item_collected(item_name) -> void:
	_remaining_collectables -= 1
	player.inventory.append(Collectable.Fruit.keys()[item_name])

	if _remaining_collectables == 0:
		_complete_level()


func _complete_level() -> void:
	await player.disappear()
	Transition.wipe_in_finished.connect(
		func():
			if level_id == 0:
				get_tree().change_scene_to_file("res://scenes/States/level_select.tscn")
			else:
				get_tree().change_scene_to_file(
					"res://scenes/Levels/level_%02d.tscn" % (level_id + 1)
				)
			PlayerManager.is_respawning = false,
		CONNECT_ONE_SHOT,
	)
	Transition.play_wipe_in()
	SaveManager.data["highest_unlocked_level"] = max(
		(level_id + 1),
		SaveManager.data["highest_unlocked_level"],
	)
	SaveManager.save_game()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"retry"):
		_restart_leve()


func _on_restart_button_pressed() -> void:
	_restart_leve()


func _restart_leve() -> void:
	player.die()
	get_tree().reload_current_scene()


func _on_levels_button_pressed() -> void:
	Transition.wipe_in_finished.connect(
		func():
			get_tree().change_scene_to_file("res://scenes/States/level_select.tscn")
			PlayerManager.is_respawning = false
			Transition.play_wipe_out(),
		CONNECT_ONE_SHOT,
	)
	Transition.play_wipe_in()
