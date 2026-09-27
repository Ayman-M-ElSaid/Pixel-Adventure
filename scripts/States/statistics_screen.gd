extends MarginContainer

@onready var background: Sprite2D = $Background
@onready var list: VBoxContainer = $VBoxContainer/List

const FRUIT_KEYS := [
	"APPLE",
	"BANANAS",
	"CHERRIES",
	"KIWI",
	"MELON",
	"ORANGE",
	"PINEAPPLE",
	"STRAWBERRY",
]
const ENEMY_KEYS := [
	"mushroom",
	"pig",
	"bird",
	"radish",
	"chicken",
	"bat",
	"bee",
	"trunk",
	"plant",
	"chameleon",
	"rhino",
	"rock",
]
const SCROLL_SPEED = -30
const WHITE_FONT = preload("res://assets/Menu/Text/Text (White) (8x10).png")


func _ready() -> void:
	_build_section("Fruit Collected", SaveManager.data["fruits_collected"], FRUIT_KEYS)
	_add_h_separator(Vector2(20, 20), 0, Color.TRANSPARENT)
	_build_section("Enemies Defeated", SaveManager.data["enemies_defeated"], ENEMY_KEYS)


func _build_section(title: String, data: Dictionary, keys: Array) -> void:
	var total := 0
	for value in data.values():
		total += value
	_add_row([title], { title: total }, true)
	_add_h_separator(Vector2.ZERO, 3, Color.WHITE)

	for i in range(0, keys.size(), 2):
		_add_row([keys[i], keys[i + 1]], data, false)


func _add_row(keys: Array, data: Dictionary, is_header: bool) -> void:
	var row := HBoxContainer.new()
	var counter := 0
	for key in keys:
		var half_row := HBoxContainer.new()
		half_row.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		counter += 1

		var label := Label.new()
		label.text = key
		label.uppercase = true
		label.size_flags_horizontal = Control.SIZE_EXPAND_FILL

		var value_panel := PanelContainer.new()
		value_panel.custom_minimum_size.x = 90

		var value_label := Label.new()
		value_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		value_label.text = str(int(data.get(key, 0)))
		value_label.uppercase = true
		value_label.add_theme_font_override(&"font", WHITE_FONT)
		value_panel.add_child(value_label)

		if is_header:
			label.add_theme_font_size_override(&"font_size", 40)
			value_label.add_theme_font_size_override(&"font_size", 40)
		else:
			label.add_theme_font_size_override(&"font_size", 30)
			value_label.add_theme_font_size_override(&"font_size", 30)

		half_row.add_child(label)
		half_row.add_child(value_panel)
		row.add_child(half_row)
		if not is_header and counter % 2 != 0:
			row.add_child(VSeparator.new())

	list.add_child(row)


func _add_h_separator(minimum_size: Vector2, thickness: int, color: Color) -> void:
	var separator := HSeparator.new()
	separator.custom_minimum_size = minimum_size

	var style_box := StyleBoxLine.new()
	style_box.thickness = thickness
	style_box.color = color
	separator.add_theme_stylebox_override(&"separator", style_box)

	list.add_child(separator)


func _process(delta: float) -> void:
	background.region_rect.position.y += SCROLL_SPEED * delta


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/States/achievements_screen.tscn")


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_cancel"):
		get_tree().change_scene_to_file("res://scenes/States/achievements_screen.tscn")
