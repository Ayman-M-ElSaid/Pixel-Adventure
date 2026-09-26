extends Node

const SAVE_PATH := "user://savegame.json"

var data: Dictionary = {
	"highest_unlocked_level": 1,
	"tutorial_seen": false,
	"character": "virtual_guy",
	"unlocked_characters": ["virtual guy"],
	"fruits_collected": { },
	"enemies_defeated": { },
	"death_count": 0,
	"achievements": [],
}


func _ready() -> void:
	load_game()


func save_game() -> void:
	AchievementManager.check_achievements(data)
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		push_error("Save failed: %s" % FileAccess.get_open_error())
		return
	file.store_string(JSON.stringify(data))
	file.close()


func load_game() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return
	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	var parsed = JSON.parse_string(file.get_as_text())
	file.close()
	if parsed is Dictionary:
		data = parsed


func complete_level(level_id: int) -> void:
	data["highest_unlocked_level"] = maxi(data["highest_unlocked_level"], level_id + 1)
	save_game()


func update_counts(items: Dictionary) -> void:
	var counts: Dictionary = data["fruits_collected"]
	for item in items:
		counts[item] = counts.get(item, 0) + items[item]
	data["fruits_collected"] = counts
	save_game()
