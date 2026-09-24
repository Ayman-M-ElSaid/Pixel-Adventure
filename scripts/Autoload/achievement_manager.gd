extends Node

const PATHS := [
	"res://resources/Achievments/50_apples.tres",
	"res://resources/Achievments/50_bananas.tres",
	"res://resources/Achievments/50_melon.tres",
	"res://resources/Achievments/50_oranges.tres",
	"res://resources/Achievments/50_pineapples.tres",
	"res://resources/Achievments/50_strawberries.tres",
	"res://resources/Achievments/50_cherries.tres",
	"res://resources/Achievments/25_kiwis.tres",
	"res://resources/Achievments/fruit_salad.tres",
	"res://resources/Achievments/all_characters_unlocked.tres",
	"res://resources/Achievments/pork_rage.tres",
	"res://resources/Achievments/grounded.tres",
	"res://resources/Achievments/sting_like_a_bee.tres",
	"res://resources/Achievments/stomp_a_stump.tres",
	"res://resources/Achievments/defeat_a_rock.tres",
	"res://resources/Achievments/squash_that.tres",
	"res://resources/Achievments/died_100.tres",
	"res://resources/Achievments/died_500.tres",
	"res://resources/Achievments/level_1_complete.tres",
	"res://resources/Achievments/level_6_complete.tres",
	"res://resources/Achievments/level_10_complete.tres",
	"res://resources/Achievments/level_12_complete.tres",
	"res://resources/Achievments/level_15_complete.tres",
	"res://resources/Achievments/level_18_complete.tres",
	"res://resources/Achievments/level_24_complete.tres",
	"res://resources/Achievments/all_levels_complete.tres",
	"res://resources/Achievments/under_100_deaths_full_clear.tres",
]
var achievement_defs: Array[AchievementDef] = []


func _ready() -> void:
	for path in PATHS:
		achievement_defs.append(load(path))
