extends Node

@onready var collectables = %Collectables
var remaining


func _ready() -> void:
	remaining = collectables.get_child_count()
	for item in collectables.get_children():
		item.collected.connect(_on_item_collected)


func _on_item_collected() -> void:
	remaining -= 1
	if remaining == 0:
		print("All collectables gathered — level complete!")
