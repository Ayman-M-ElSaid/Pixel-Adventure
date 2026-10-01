extends MarginContainer

@onready var background: Sprite2D = $Background
@onready var animated_sprite: AnimatedSprite2D = %AnimatedSprite
@onready var previous_button: TextureButton = %PreviousButton
@onready var next_button: TextureButton = %NextButton
@onready var label_background: PanelContainer = %LabelBackground
@onready var label: Label = %Label
@onready var error_sound: AudioStreamPlayer2D = $ErrorSound

const SCROLL_SPEED = -30
const BUTTON_SCRIPT = preload("res://scripts/UI/button.gd")
const REQUIRED_ACHIEVEMENTS = [
	"",
	"melon drama",
	"going bananas and prickly customer",
	"cherry on top and kiwi konnoisseur",
]
const WHITE_FONT = preload("res://assets/Menu/Text/Text (White) (8x10).png")

var characters := Characters.CHARACTERS.keys()
var selection := 0
var active_character: String


func _ready() -> void:
	Transition.play_wipe_out()

	active_character = SaveManager.data["character"]
	animated_sprite.sprite_frames = Characters.CHARACTERS[active_character]
	animated_sprite.play(&"idle")
	selection = characters.find(active_character)
	_update_buttons()
	_update_label()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_right"):
		_update_selection(1)
	elif event.is_action_pressed(&"ui_left"):
		_update_selection(-1)
	elif event.is_action_pressed(&"ui_accept"):
		_try_select()

	elif event.is_action_pressed(&"ui_cancel"):
		_exit()


func _on_sub_viewport_container_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		_try_select()


func _try_select() -> void:
	if active_character in SaveManager.data["unlocked_characters"]:
		SaveManager.data["character"] = active_character
		SaveManager.save_game()
		_exit()
	else:
		$ErrorSound.play()


func _process(delta: float) -> void:
	background.region_rect.position.y += SCROLL_SPEED * delta


func _on_next_button_pressed() -> void:
	_update_selection(1)


func _on_previous_button_pressed() -> void:
	_update_selection(-1)


func _update_selection(step: int) -> void:
	var new_selection := selection + step

	if new_selection >= 0 and new_selection < characters.size():
		selection = new_selection
	else:
		error_sound.play()
	_change_character()
	_update_buttons()
	_update_label()


func _change_character() -> void:
	active_character = characters[selection]
	animated_sprite.sprite_frames = Characters.CHARACTERS[active_character]
	animated_sprite.modulate = (
		Color(1, 1, 1, 1)
		if active_character in SaveManager.data["unlocked_characters"]
		else Color(.3, .3, .3, 1)
	)
	animated_sprite.play(&"idle")


func _update_buttons() -> void:
	if selection == 0:
		previous_button.set_script(null)
		previous_button.modulate = Color(0.3, 0.3, 0.3, 0.5)
	elif selection == 3:
		next_button.set_script(null)
		next_button.modulate = Color(0.3, 0.3, 0.3, 0.5)
	else:
		previous_button.set_script(BUTTON_SCRIPT)
		previous_button.modulate = Color(1, 1, 1, 1)
		next_button.set_script(BUTTON_SCRIPT)
		next_button.modulate = Color(1, 1, 1, 1)


func _update_label() -> void:
	var input_method := "tap the character " if DisplayServer.is_touchscreen_available() else "press space "
	if active_character in SaveManager.data["unlocked_characters"]:
		label.text = input_method + "to select " + active_character
		label.remove_theme_font_override(&"font")
		var style_box = StyleBoxFlat.new()
		style_box.bg_color = Color.TRANSPARENT
		label_background.add_theme_stylebox_override(&"panel", style_box)
	else:
		label.text = "complete " + REQUIRED_ACHIEVEMENTS[selection] + " to unlock " + active_character
		label.add_theme_font_override(&"font", WHITE_FONT)
		label_background.remove_theme_stylebox_override(&"panel")


func _on_back_button_pressed():
	_exit()


func _exit() -> void:
	Transition.wipe_in_finished.connect(
		func():
			get_tree().change_scene_to_file("res://scenes/States/level_select.tscn"),
		CONNECT_ONE_SHOT,
	)
	Transition.play_wipe_in()
