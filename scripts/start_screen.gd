extends Node2D


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://scenes/States/level_select.tscn")
	elif Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/States/level_select.tscn")
