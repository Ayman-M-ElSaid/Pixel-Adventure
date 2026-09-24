extends PanelContainer

@onready var icon: TextureRect = %Icon
@onready var title_label: Label = %Title
@onready var desc_label: Label = %Description


func setup(def: AchievementDef) -> void:
	icon.texture = def.icon
	title_label.text = def.title
	desc_label.text = def.description
