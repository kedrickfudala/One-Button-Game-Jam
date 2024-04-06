extends Node2D
class_name MapSegment

@onready var near_player : bool = true

func _process(delta):
	if !near_player:
		destroy_segment()

func destroy_segment():
	self.queue_free()

func _on_map_area_area_entered(_area):
	near_player = true

func _on_map_area_area_exited(_area):
	near_player = false
