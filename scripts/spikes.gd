extends Hazard

@export var length: int = 2

@onready var sprite = $Sprite2D
@onready var collision_rect = $CollisionShape2D

const SPIKES_HEIGHT = 8
const SPIKES_WIDTH = 16


func _ready() -> void:
	var total_width = SPIKES_WIDTH * length
	var offset_x = (total_width - SPIKES_WIDTH) / 2.0
	sprite.region_rect = Rect2i(0, 0, total_width, SPIKES_HEIGHT)
	sprite.position.x = offset_x
	collision_rect.shape = collision_rect.shape.duplicate()
	collision_rect.shape.size.x = total_width
	collision_rect.position.x = offset_x
