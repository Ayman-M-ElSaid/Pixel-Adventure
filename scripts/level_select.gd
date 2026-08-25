extends Node2D

@onready var background = $Background

const LEVEL_COUNT := 30
const COLS := 6
const ROWS := LEVEL_COUNT / COLS
const SCROLL_SPEED = -30


func _ready() -> void:
	for i in range(COLS):
		for j in range(ROWS):
			var button := TextureButton.new()
			var level_id = (i + 1) + (j * COLS)
			button.texture_normal = load("res://assets/Menu/Levels/%02d.png" % level_id)
			button.position = Vector2(-288 + ((i + 1) * 48) + (i * 40), -95 + (j * 50))
			button.ignore_texture_size = true
			button.stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
			button.size = Vector2(40, 40)
			if level_id > SaveManager.data["highest_unlocked_level"]:
				button.disabled = true
				button.modulate = Color(0.3, 0.3, 0.3, 0.5)
			button.pressed.connect(_on_level_pressed.bind(level_id))
			add_child(button)


func _process(delta: float) -> void:
	background.region_rect.position.y += SCROLL_SPEED * delta
	if Input.is_action_just_pressed("ui_accept"):
		_go_to_level(SaveManager.data["highest_unlocked_level"])
	elif Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/States/start_screen.tscn")


func _go_to_level(level_id):
	Transition.wipe_in_finished.connect(
		func():
			get_tree().change_scene_to_file("res://scenes/Levels/level_%02d.tscn" % level_id),
		CONNECT_ONE_SHOT,
	)
	Transition.play_wipe_in()


func _on_level_pressed(level_id: int) -> void:
	_go_to_level(level_id)
