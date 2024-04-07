extends CanvasLayer
class_name GameOverMenu

@onready var high_score_label : Object = $HighScoreLabel
@onready var world : Object = get_parent()

func _process(_delta):
	high_score_label.text = "high score: " + str(world.high_score)
