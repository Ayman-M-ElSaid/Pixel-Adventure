extends Node2D

@onready var background = $Background
@onready var tutorial_overlay = $TutorialOverlay

const LEVEL_COUNT := 30
const COLS := 6
const ROWS := LEVEL_COUNT / COLS
const SCROLL_SPEED = -30

var level_buttons: Array[TextureButton] = []


func _ready() -> void:
	# build buttons grid
	for i in range(COLS):
		for j in range(ROWS):
			var button := TextureButton.new()
			var level_id = (i + 1) + (j * COLS)
			button.texture_normal = load("res://assets/Menu/Levels/%02d.png" % level_id)
			button.position = Vector2(-288 + ((i + 1) * 48) + (i * 40), -95 + (j * 50))
			button.ignore_texture_size = true
			button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
			button.size = Vector2(40, 40)
			if level_id > SaveManager.data.get("highest_unlocked_level", 1):
				button.disabled = true
				button.modulate = Color(0.3, 0.3, 0.3, 0.5)
			else:
				button.set_script(preload("res://scripts/UI/button.gd"))
			button.pressed.connect(_on_level_pressed.bind(level_id))
			add_child(button)
			level_buttons.append(button)

	# show tutorial if it's the player's first time
	if not SaveManager.data.get("tutorial_seen", false):
		tutorial_overlay.show()
		tutorial_overlay.tutorial_finished.connect(_on_tutorial_finished)
		tutorial_overlay.start(
			[
				{ "target": %CharacterSelectButton, "text": "change your character" },
				{ "target": %AchievementsButton, "text": "view your achievements" },
				{ "rect": get_level_grid_rect(), "text": "pick a level to play" },
			]
		)


func get_level_grid_rect() -> Rect2:
	var rect := level_buttons[0].get_global_rect()
	for button in level_buttons:
		rect = rect.merge(button.get_global_rect())
	return rect


func _unhandled_input(event: InputEvent):
	if event.is_action_pressed(&"ui_accept"):
		_go_to_level(SaveManager.data["highest_unlocked_level"])
	elif event.is_action_pressed(&"ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/States/start_screen.tscn")


func _process(delta: float) -> void:
	background.region_rect.position.y += SCROLL_SPEED * delta


func _on_level_pressed(level_id: int) -> void:
	_go_to_level(level_id)


func _on_character_select_button_pressed():
	get_tree().change_scene_to_file("res://scenes/States/character_select.tscn")


func _go_to_level(level_id):
	Transition.wipe_in_finished.connect(
		func():
			get_tree().change_scene_to_file("res://scenes/Levels/level_%02d.tscn" % level_id),
		CONNECT_ONE_SHOT,
	)
	Transition.play_wipe_in()


func _on_tutorial_finished() -> void:
	SaveManager.data["tutorial_seen"] = true
	SaveManager.save_game()
