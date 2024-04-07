extends Node2D

@onready var map_segment : PackedScene = preload("res://src/levels/map_segment.tscn")
@onready var player_scene : PackedScene = preload("res://src/player.tscn")
@onready var player : Object

func _ready():
	RenderingServer.set_default_clear_color(Color.SKY_BLUE)
	spawn_player()
	spawn_map(0)
	spawn_map(1)
	
func _process(delta):
	pass

func spawn_player():
	var player_inst = player_scene.instantiate()
	player_inst.global_position = Vector2(0, 0)
	add_child(player_inst)
	player = get_node("Player")

func spawn_map(offset : int):
	var map_inst = map_segment.instantiate()
	map_inst.global_position = Vector2(offset * 16 * 20, 0)
	map_inst.offset = offset
	add_child(map_inst)
