extends CanvasLayer

@export var tile_texture: Texture2D
@export var tile_size: int = 44
@export var stagger: float = 0.035
@export var tile_duration: float = 0.1
@export var fill_scale := 2

signal wipe_in_finished
signal wipe_out_finished

var _tiles: Array[Sprite2D] = []
var _delays: Array[float] = []


func _ready() -> void:
	layer = 100
	_build_grid()


func _build_grid() -> void:
	var view_point := get_viewport().get_visible_rect().size
	var cols := int(ceil(view_point.x / tile_size)) + 1
	var rows := int(ceil(view_point.y / tile_size)) + 1

	for row in rows:
		for col in cols:
			var tile := Sprite2D.new()
			tile.texture = tile_texture
			tile.position = Vector2(col * tile_size, row * tile_size) + Vector2(
				tile_size,
				tile_size,
			) / 2.0
			tile.scale = Vector2.ZERO
			add_child(tile)
			_tiles.append(tile)
			_delays.append((cols - 1 - col) * stagger)


func play_wipe_in() -> void:
	var tween := create_tween().set_parallel(true)
	for i in _tiles.size():
		tween \
				.tween_property(_tiles[i], "scale", Vector2.ONE * fill_scale, tile_duration) \
				.set_delay(_delays[i]) \
				.set_trans(Tween.TRANS_BACK) \
				.set_ease(Tween.EASE_OUT)
	tween.finished.connect(
		func():
			wipe_in_finished.emit(),
	)


func play_wipe_out() -> void:
	var tween := create_tween().set_parallel(true)
	for i in _tiles.size():
		tween \
				.tween_property(_tiles[i], "scale", Vector2.ZERO, tile_duration) \
				.set_delay(_delays[i]) \
				.set_trans(Tween.TRANS_BACK) \
				.set_ease(Tween.EASE_IN)
	tween.finished.connect(
		func():
			wipe_out_finished.emit(),
	)
