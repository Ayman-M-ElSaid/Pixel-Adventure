extends PanelContainer

@onready var icon: TextureRect = %Icon
@onready var title: Label = %Title
@onready var description: Label = %Description


func setup(def: AchievementDef) -> void:
	icon.texture = def.icon
	title.text = def.title
	description.text = def.description
