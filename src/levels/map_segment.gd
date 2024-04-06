extends Node2D
class_name MapSegment

@onready var near_player : bool = true
@onready var world : Object = get_parent()
@onready var offset : int = global_position.x / (16 * 20)
@onready var player_inst : Object = world.player

func _process(delta):
	if !near_player:
		if player_inst.global_position.x > self.global_position.x:
			world.spawn_map(offset + 2)
		else:
			world.spawn_map(offset - 2)
		destroy_segment()

func destroy_segment():
	self.queue_free()

func _on_map_area_area_entered(_area):
	near_player = true

func _on_map_area_area_exited(_area):
	near_player = false
