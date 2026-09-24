extends Node2D

@onready var background: Sprite2D = $Background
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite

const OPTIONS = ["virtual_guy", "pink_man", "mask_dude", "ninja_frog"]
const SCROLL_SPEED = -30

var selection := 0


func _ready() -> void:
	Transition.play_wipe_out()

	var chosen_character = SaveManager.data["character"]
	animated_sprite.sprite_frames = Characters.CHARACTERS[chosen_character]
	animated_sprite.play(&"idle")
	selection = OPTIONS.find(chosen_character)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_right"):
		_increment_selection()
	elif event.is_action_pressed(&"ui_left"):
		_decrement_selection()
	elif event.is_action_pressed(&"ui_accept"):
		var active_character = OPTIONS[selection]
		if active_character in SaveManager.data["unlocked_characters"]:
			SaveManager.data["character"] = active_character
			SaveManager.save_game()
			get_tree().change_scene_to_file("res://scenes/States/level_select.tscn")
		else:
			$ErrorSound.play()
	elif event.is_action_pressed(&"ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/States/level_select.tscn")

	_change_character()
	_update_buttons()


func _process(delta: float) -> void:
	background.region_rect.position.y += SCROLL_SPEED * delta


func _on_next_button_pressed() -> void:
	_increment_selection()


func _on_back_button_pressed() -> void:
	_decrement_selection()


func _increment_selection() -> void:
	if selection < OPTIONS.size() - 1:
		selection += 1
	else:
		$ErrorSound.play()


func _decrement_selection() -> void:
	if selection > 0:
		selection -= 1
	else:
		$ErrorSound.play()


func _change_character() -> void:
	var active_character = OPTIONS[selection]
	animated_sprite.sprite_frames = Characters.CHARACTERS[active_character]
	animated_sprite.modulate = (
		Color(1, 1, 1, 1)
		if active_character in SaveManager.data["unlocked_characters"]
		else Color(.3, .3, .3, 1)
	)
	animated_sprite.play(&"idle")


func _update_buttons() -> void:
	$BackButton.modulate = Color(0.3, 0.3, 0.3, 0.5) if selection == 0 else Color(1, 1, 1, 1)
	$NextButton.modulate = Color(0.3, 0.3, 0.3, 0.5) if selection == 3 else Color(1, 1, 1, 1)
