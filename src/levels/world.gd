extends Node2D

@onready var map_segment : PackedScene = preload("res://src/levels/map_segment.tscn")
@onready var player_scene : PackedScene = preload("res://src/player.tscn")
@onready var player : Object

@onready var draw_timer : Object = $DrawTimer

@onready var target_x = null
@onready var gun_pos = null
@onready var shot_colors : Array = [Color.RED, Color.ORANGE, Color.YELLOW, Color.GREEN, Color.DEEP_SKY_BLUE, Color.PURPLE]
@onready var shot_color : Color = shot_colors[0]

func _ready():
	RenderingServer.set_default_clear_color(Color.SKY_BLUE)
	draw_timer.wait_time = 0.1
	spawn_player()
	spawn_map(0)
	spawn_map(1)
	
func _process(delta):
	if draw_timer.is_stopped():
		target_x = null
		gun_pos = null
		queue_redraw()
	pass

func spawn_player():
	var player_inst = player_scene.instantiate()
	add_child(player_inst)
	player_inst.global_position = Vector2(0, 0)
	player = get_node("Player")

func spawn_map(offset : int):
	var map_inst = map_segment.instantiate()
	add_child(map_inst)
	map_inst.global_position = Vector2(offset * 16 * 20, 0)
	map_inst.offset = offset

func draw_shot(gun_pos, target_x, chamber_slot):
	self.gun_pos = gun_pos
	self.target_x = target_x
	self.shot_color = shot_colors[chamber_slot]
	queue_redraw()
	draw_timer.start()
	
func _draw():
	if target_x and gun_pos:
		draw_line(gun_pos, Vector2(target_x, gun_pos.y), shot_color, 1.0)
