extends Control
class_name MainMenuButtons

@onready var world : Object = get_parent().get_parent()

func _on_play_button_pressed():
	world.new_game()
	self.queue_free()

func _on_quit_button_pressed():
	get_tree().quit()
