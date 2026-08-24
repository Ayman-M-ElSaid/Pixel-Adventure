extends Sprite2D

@onready var level_manager = %LevelManager

const PATH = "res://assets/Background/"
const BACKGROUNDS = [
	preload(PATH + "Blue.png"),
	preload(PATH + "Brown.png"),
	preload(PATH + "Gray.png"),
	preload(PATH + "Green.png"),
	preload(PATH + "Pink.png"),
	preload(PATH + "Purple.png"),
	preload(PATH + "Yellow.png"),
]
const SCROLL_SPEED = 30


func _ready() -> void:
	seed(1)
	texture = BACKGROUNDS[randi_range(0, BACKGROUNDS.size() - 1)]
	texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	region_enabled = true
	centered = false

	var level_dimension = level_manager.get_level_dimensions()
	var tile_size: Vector2 = texture.get_size()
	var rows := ceili(level_dimension["level_size"].x / tile_size.x)
	var cols := ceili(level_dimension["level_size"].y / tile_size.y)
	region_rect = Rect2(Vector2.ZERO, tile_size * Vector2(rows, cols))
	position = level_dimension["topleft"]


func _process(delta: float) -> void:
	region_rect.position.y += SCROLL_SPEED * delta
