extends Node2D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_accept"):
		get_tree().change_scene_to_file("res://scenes/States/level_select.tscn")
	elif event.is_action_pressed(&"ui_cancel"):
		get_tree().quit()


func _on_start_button_pressed() -> void:
	Transition.wipe_in_finished.connect(
		func():
			if SaveManager.data["tutorial_seen"]:
				get_tree().change_scene_to_file("res://scenes/States/level_select.tscn")
			else:
				get_tree().change_scene_to_file("res://scenes/Levels/level_00.tscn")
				PlayerManager.is_respawning = false,
		CONNECT_ONE_SHOT,
	)
	Transition.play_wipe_in()
