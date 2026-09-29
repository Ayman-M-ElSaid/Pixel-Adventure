extends Node

const PATHS := [
	"res://resources/Achievements/apple_50.tres",
	"res://resources/Achievements/bananas_50.tres",
	"res://resources/Achievements/melon_50.tres",
	"res://resources/Achievements/orange_50.tres",
	"res://resources/Achievements/pineapple_50.tres",
	"res://resources/Achievements/strawberry_50.tres",
	"res://resources/Achievements/cherries_50.tres",
	"res://resources/Achievements/kiwi_25.tres",
	"res://resources/Achievements/fruit_salad.tres",
	"res://resources/Achievements/all_characters_unlocked.tres",
	"res://resources/Achievements/pork_rage.tres",
	"res://resources/Achievements/grounded.tres",
	"res://resources/Achievements/sting_like_a_bee.tres",
	"res://resources/Achievements/stomp_a_stump.tres",
	"res://resources/Achievements/defeat_a_rock.tres",
	"res://resources/Achievements/squash_that.tres",
	"res://resources/Achievements/died_100.tres",
	"res://resources/Achievements/died_500.tres",
	"res://resources/Achievements/level_1_complete.tres",
	"res://resources/Achievements/level_6_complete.tres",
	"res://resources/Achievements/level_10_complete.tres",
	"res://resources/Achievements/level_12_complete.tres",
	"res://resources/Achievements/level_15_complete.tres",
	"res://resources/Achievements/level_18_complete.tres",
	"res://resources/Achievements/level_24_complete.tres",
	"res://resources/Achievements/all_levels_complete.tres",
	"res://resources/Achievements/under_100_deaths_full_clear.tres",
]
var achievement_defs: Array[AchievementDef] = []

signal achievement_unlocked(id: String)


func _ready() -> void:
	for path in PATHS:
		achievement_defs.append(load(path))


func check_achievements(data: Dictionary) -> void:
	var unlocked: Array = data.get("achievements", [])

	var fruits: Dictionary = data["fruits_collected"]
	_try_unlock(unlocked, "apple_50", fruits.get("APPLE", 0) >= 50)
	_try_unlock(unlocked, "bananas_50", fruits.get("BANANAS", 0) >= 50)
	_try_unlock(unlocked, "cherries_50", fruits.get("CHERRIES", 0) >= 50)
	_try_unlock(unlocked, "kiwi_25", fruits.get("KIWI", 0) >= 25)
	_try_unlock(unlocked, "melon_50", fruits.get("MELON", 0) >= 50)
	_try_unlock(unlocked, "orange_50", fruits.get("ORANGE", 0) >= 50)
	_try_unlock(unlocked, "pineapple_50", fruits.get("PINEAPPLE", 0) >= 50)
	_try_unlock(unlocked, "strawberry_50", fruits.get("STRAWBERRY", 0) >= 50)

	var enemies: Dictionary = data["enemies_defeated"]
	_try_unlock(unlocked, "pork_rage", enemies.get("pig", 0) >= 1)
	_try_unlock(unlocked, "sting_like_a_bee", enemies.get("bee", 0) >= 1)
	_try_unlock(unlocked, "stomp_a_stump", enemies.get("trunk", 0) >= 1)
	_try_unlock(unlocked, "defeat_a_rock", enemies.get("rock", 0) >= 1)
	_try_unlock(unlocked, "squash_that", enemies.size() == 12)

	var highest_level: int = data["highest_unlocked_level"]
	_try_unlock(unlocked, "level_1_complete", highest_level > 1)
	_try_unlock(unlocked, "level_6_complete", highest_level > 6)
	_try_unlock(unlocked, "level_10_complete", highest_level > 10)
	_try_unlock(unlocked, "level_12_complete", highest_level > 12)
	_try_unlock(unlocked, "level_15_complete", highest_level > 15)
	_try_unlock(unlocked, "level_18_complete", highest_level > 18)
	_try_unlock(unlocked, "level_24_complete", highest_level > 24)
	_try_unlock(unlocked, "all_levels_complete", highest_level > 30)

	var deaths: int = data["death_count"]
	_try_unlock(unlocked, "died_100", deaths >= 100)
	_try_unlock(unlocked, "died_500", deaths >= 500)
	_try_unlock(unlocked, "under_100_deaths_full_clear", highest_level > 30 and deaths < 100)

	var unlocked_characters: Array = data.get("unlocked_characters", ["virtual guy"])
	if unlocked.has("melon_50") and not unlocked_characters.has("pink man"):
		unlocked_characters.append("pink man")
	if (
		unlocked.has("bananas_50") and unlocked.has("pineapple_50")
		and not unlocked_characters.has("mask dude")
	):
		unlocked_characters.append("mask dude")
	if (
		unlocked.has("cherries_50") and unlocked.has("kiwi_25")
		and not unlocked_characters.has("ninja frog")
	):
		unlocked_characters.append("ninja frog")
	data["unlocked_characters"] = unlocked_characters
	_try_unlock(unlocked, "all_characters_unlocked", unlocked_characters.size() == 4)

	data["achievements"] = unlocked


func _try_unlock(unlocked: Array, id: String, condition: bool) -> void:
	if condition and not unlocked.has(id):
		unlocked.append(id)
		achievement_unlocked.emit(id)


func try_unlock(id: String) -> void:
	var unlocked: Array = SaveManager.data.get("achievements", [])
	if not unlocked.has(id):
		unlocked.append(id)
		SaveManager.data["achievements"] = unlocked
		achievement_unlocked.emit(id)


func get_def(id: String) -> AchievementDef:
	for def in achievement_defs:
		if def.id == id:
			return def
	return null
