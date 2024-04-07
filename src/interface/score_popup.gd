extends CanvasLayer
class_name ScorePopup

@onready var label = $Label

func _ready():
	var tween = create_tween()
	tween.tween_property(label, "modulate", Color(255, 255, 255, 0), 10)
	await(tween.finished)
	queue_free()
