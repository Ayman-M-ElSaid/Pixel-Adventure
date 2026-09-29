extends Node2D

@onready var achievements_button: TextureButton = $AchievementsButton


func _ready() -> void:
	Transition.play_wipe_out()
	achievements_button.visible = SaveManager.data["tutorial_seen"]


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_accept"):
		_on_start_button_pressed()
	elif event.is_action_pressed(&"ui_cancel"):
		if not OS.has_feature("web"):
			get_tree().quit()


func _on_start_button_pressed() -> void:
	Transition.wipe_in_finished.connect(
		func():
			if SaveManager.data["tutorial_seen"]:
				get_tree().change_scene_to_file("res://scenes/States/level_select.tscn")
			else:
				get_tree().change_scene_to_file("res://scenes/Levels/level_00.tscn"),
		CONNECT_ONE_SHOT,
	)
	Transition.play_wipe_in()


func _on_achievements_button_pressed() -> void:
	Transition.wipe_in_finished.connect(
		func():
			get_tree().change_scene_to_file("res://scenes/States/achievements_screen.tscn"),
		CONNECT_ONE_SHOT,
	)
	Transition.play_wipe_in()
