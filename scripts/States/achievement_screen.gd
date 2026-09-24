extends MarginContainer

@export var badge_scene: PackedScene

@onready var list = $VBoxContainer/ScrollContainer/List
@onready var background: Sprite2D = $Background

const SCROLL_SPEED = -30


func _ready() -> void:
	Transition.play_wipe_out()

	for def in AchievementManager.achievement_defs:
		var badge: PanelContainer = badge_scene.instantiate()
		list.add_child(badge)
		badge.setup(def)

		if not SaveManager.data["achievements"].has(def.id):
			badge.modulate = Color.DIM_GRAY


func _process(delta: float) -> void:
	background.region_rect.position.y += SCROLL_SPEED * delta


func _on_back_button_pressed() -> void:
	Transition.wipe_in_finished.connect(
		func():
			get_tree().change_scene_to_file("res://scenes/States/level_select.tscn"),
		CONNECT_ONE_SHOT,
	)
	Transition.play_wipe_in()
