extends CharacterBody2D
class_name Player

func _ready():
	pass

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		print("One Button!")
	pass
