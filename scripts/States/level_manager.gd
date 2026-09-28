extends Node

@export var level_id: int

@onready var tilemap: TileMapLayer = %TileMap
@onready var collectables: Node2D = %Collectables
@onready var enemies: Node2D = %Enemies
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

	for enemy in enemies.get_children():
		enemy.died.connect(_on_enemy_death)


func _on_item_collected(item_name) -> void:
	_remaining_collectables -= 1
	player.inventory.append(Collectable.Fruit.keys()[item_name])
	if _remaining_collectables == 0:
		_complete_level()


func _on_enemy_death(enemy_type) -> void:
	var enemies_defeated: Dictionary = SaveManager.data["enemies_defeated"]
	enemies_defeated[enemy_type] = enemies_defeated.get(enemy_type, 0) + 1
	SaveManager.data["enemies_defeated"] = enemies_defeated
	SaveManager.save_game()


func _complete_level() -> void:
	await player.disappear()
	Transition.wipe_in_finished.connect(
		func():
			if level_id == 0:
				get_tree().change_scene_to_file("res://scenes/States/level_select.tscn")
			elif level_id == 30:
				get_tree().change_scene_to_file("res://scenes/States/end_screen.tscn")
			else:
				get_tree().change_scene_to_file(
					"res://scenes/Levels/level_%02d.tscn" % (level_id + 1)
				)
			PlayerManager.is_respawning = false,
		CONNECT_ONE_SHOT,
	)
	Transition.play_wipe_in()

	var unique_collectables := { }
	var total_collectables := { }
	for item in player.inventory:
		unique_collectables[item] = true
		total_collectables[item] = player.inventory.count(item)
	if unique_collectables.size() == 8:
		AchievementManager.try_unlock("fruit_salad")
	SaveManager.update_counts(total_collectables)
	SaveManager.complete_level(level_id)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"retry"):
		_restart_leve()
	elif event.is_action_pressed(&"ui_cancel"):
		_on_levels_button_pressed()


func _on_restart_button_pressed() -> void:
	_restart_leve()


func _restart_leve() -> void:
	player.die()
	get_tree().reload_current_scene()


func _on_levels_button_pressed() -> void:
	Transition.wipe_in_finished.connect(
		func():
			get_tree().change_scene_to_file("res://scenes/States/level_select.tscn")
			PlayerManager.is_respawning = false,
		CONNECT_ONE_SHOT,
	)
	Transition.play_wipe_in()
