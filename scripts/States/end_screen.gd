extends Control

@onready var label = $Label

var _is_finished := false


func _ready():
	Transition.play_wipe_out()
	await Transition.wipe_out_finished
	var data := SaveManager.data
	var fruits = 0
	for value in data["fruits_collected"].values():
		fruits += value

	var enemies = 0
	for value in data["enemies_defeated"].values():
		enemies += value

	var deaths = data["death_count"]

	label.text = """
		And that is all!


		You made it through every trap, every enemy, and every ridiculous obstacle we could throw at you.

		%d fruits collected, %d enemies stomped and only %d deaths.
		
		One very well-earned victory!

		Nice work.
	""" % [fruits, enemies, deaths]
	label.visible_characters = 0
	_type_text()


const BASE_LINE_DURATION := 1.0
const MIN_CHAR_SPEED := 0.025
const MAX_CHAR_SPEED := 0.060
const PAUSE_BETWEEN_LINES := 0.35


func _type_text() -> void:
	var lines: PackedStringArray = label.text.split("\n")
	var shown_characters := 0
	for line in lines:
		# empty lines
		if line.strip_edges() == "":
			shown_characters += line.length() + 1
			label.visible_characters = shown_characters
			await get_tree().create_timer(PAUSE_BETWEEN_LINES).timeout
			continue
		# lines with text
		var char_speed: float = clampf(
			BASE_LINE_DURATION / line.length(),
			MIN_CHAR_SPEED,
			MAX_CHAR_SPEED,
		)
		for i in line.length():
			shown_characters += 1
			label.visible_characters = shown_characters
			await get_tree().create_timer(char_speed).timeout
		# new line character
		shown_characters += 1
		label.visible_characters = shown_characters
		await get_tree().create_timer(PAUSE_BETWEEN_LINES).timeout

	_is_finished = true


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("ui_accept") and _is_finished:
		Transition.wipe_in_finished.connect(
			func():
				get_tree().change_scene_to_file("res://scenes/States/level_select.tscn"),
			CONNECT_ONE_SHOT,
		)
		Transition.play_wipe_in()
