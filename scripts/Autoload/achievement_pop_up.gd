extends CanvasLayer

const display_seconds := 1.5
const tween_duration := 0.4

const HIDDEN_Y := -100
const SHOWN_Y := 0
@onready var achievement_badge: PanelContainer = $AchievementBadge
@onready var sfx: AudioStreamPlayer = $SFX

var _queue: Array[String] = []
var _busy := false


func _ready() -> void:
	achievement_badge.position.y = HIDDEN_Y
	AchievementManager.achievement_unlocked.connect(_on_achievement_unlocked)


func _on_achievement_unlocked(id: String) -> void:
	_queue.append(id)
	_advance_queue()


func _advance_queue() -> void:
	if _busy or _queue.is_empty():
		return
	var def = AchievementManager.get_def(_queue.pop_front())
	if def == null:
		_advance_queue()
		return

	_busy = true
	achievement_badge.setup(def)
	sfx.play()

	var tween := create_tween()
	tween.tween_property(achievement_badge, "position:y", SHOWN_Y, tween_duration) \
			.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_interval(display_seconds)
	tween.tween_property(achievement_badge, "position:y", HIDDEN_Y, tween_duration) \
			.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_IN)
	tween.tween_callback(
		func():
			_busy = false
			_advance_queue(),
	)
