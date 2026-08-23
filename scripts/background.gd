extends Sprite2D

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
@onready var tilemap = get_node("../TileMapLayer")


func _ready() -> void:
	seed(1)
	texture = BACKGROUNDS[randi() % BACKGROUNDS.size()]

	texture_repeat = CanvasItem.TEXTURE_REPEAT_ENABLED
	region_enabled = true
	centered = false

	var used_rect = tilemap.get_used_rect()
	var cell_size = Vector2(tilemap.tile_set.tile_size)
	position = Vector2(used_rect.position) * cell_size
	var level_pixel_size: Vector2 = Vector2(used_rect.size) * cell_size

	var tile_size: Vector2 = texture.get_size()
	var rows := ceili(level_pixel_size.x / tile_size.x) #+ tile_padding
	var cols := ceili(level_pixel_size.y / tile_size.y) #+ tile_padding
	region_rect = Rect2(Vector2.ZERO, tile_size * Vector2(rows, cols))


func _process(delta: float) -> void:
	region_rect.position.y += SCROLL_SPEED * delta
