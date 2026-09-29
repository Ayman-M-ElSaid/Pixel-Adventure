extends MarginContainer

@onready var background: Sprite2D = $Background
@onready var tutorial_overlay: CanvasLayer = $TutorialOverlay
@onready var buttons_grid: GridContainer = %ButtonsGrid
@onready var confetti: CPUParticles2D = $Confetti

const LEVEL_COUNT := 30.0
const COLS := 6
const ROWS := LEVEL_COUNT / COLS
const SCROLL_SPEED = -30


func _ready() -> void:
	Transition.play_wipe_out()

	# build buttons buttons_grid
	buttons_grid.columns = COLS
	for i in range(ROWS):
		for j in range(COLS):
			var button := TextureButton.new()
			var level_id = (j + 1) + (i * COLS)
			button.texture_normal = load("res://assets/Menu/Levels/%02d.png" % level_id)
			button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
			button.custom_minimum_size = Vector2(80, 80)
			if level_id > SaveManager.data.get("highest_unlocked_level", 1):
				button.disabled = true
				button.modulate = Color(0.3, 0.3, 0.3, 0.5)
			else:
				button.set_script(preload("res://scripts/UI/button.gd"))
			button.pressed.connect(_on_level_pressed.bind(level_id))
			buttons_grid.add_child(button)

	await get_tree().process_frame
	for button in buttons_grid.get_children():
		if button.get_script():
			button.original_position = button.position

	# show tutorial if it's the player's first time
	if not SaveManager.data.get("tutorial_seen", false):
		tutorial_overlay.show()
		tutorial_overlay.tutorial_finished.connect(_on_tutorial_finished)
		tutorial_overlay.start(
			[
				{ "target": %CharacterSelectButton, "text": "change your character" },
				{ "target": %AchievementsButton, "text": "view your achievements" },
				{ "target": %ButtonsGrid, "text": "pick a level to play" },
			]
		)
	# emit confitte particles if its the first time finishing the last level
	if SaveManager.data.get("highest_unlocked_level", 1) > 30 and not SaveManager.data.get(
			"end_screen_seen",
			false,
		):
		await Transition.wipe_out_finished
		confetti.emitting = true
		SaveManager.data["end_screen_seen"] = true
		SaveManager.save_game()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_accept"):
		_go_to_level(mini(SaveManager.data["highest_unlocked_level"], 30))
	elif event.is_action_pressed(&"ui_cancel"):
		Transition.wipe_in_finished.connect(
			func():
				get_tree().change_scene_to_file("res://scenes/States/start_screen.tscn"),
			CONNECT_ONE_SHOT,
		)
		Transition.play_wipe_in()


func _process(delta: float) -> void:
	background.region_rect.position.y += SCROLL_SPEED * delta


func _on_level_pressed(level_id: int) -> void:
	_go_to_level(level_id)


func _go_to_level(level_id) -> void:
	Transition.wipe_in_finished.connect(
		func():
			get_tree().change_scene_to_file("res://scenes/Levels/level_%02d.tscn" % level_id),
		CONNECT_ONE_SHOT,
	)
	Transition.play_wipe_in()


func _on_tutorial_finished() -> void:
	SaveManager.data["tutorial_seen"] = true
	SaveManager.save_game()


func _on_character_select_button_pressed() -> void:
	Transition.wipe_in_finished.connect(
		func():
			get_tree().change_scene_to_file("res://scenes/States/character_select.tscn"),
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
