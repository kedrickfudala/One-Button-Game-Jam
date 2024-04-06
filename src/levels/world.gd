extends Node2D

@onready var map_segment : PackedScene = preload("res://src/levels/map_segment.tscn")

func _ready():
	RenderingServer.set_default_clear_color(Color.LIGHT_SLATE_GRAY)
	spawn_map()
	pass
	
func _process(delta):
	pass

func spawn_map():
	var map_inst = map_segment.instantiate()
	map_inst.global_position = Vector2(0, 0)
	add_child(map_inst)
