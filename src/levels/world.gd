extends Node2D

@onready var map_segment : PackedScene = preload("res://src/levels/map_segment.tscn")
@onready var player_scene : PackedScene = preload("res://src/player.tscn")
@onready var canyon_background : PackedScene = preload("res://src/levels/canyon_background.tscn")

@onready var game_over_menu : PackedScene = preload("res://src/interface/game_over_menu.tscn")

@onready var player : Object
@onready var draw_timer : Object

@onready var target_x = null
@onready var gun_pos = null
@onready var shot_colors : Array = [Color.RED, Color.ORANGE, Color.YELLOW, Color.GREEN, Color.DEEP_SKY_BLUE, Color.PURPLE]
@onready var shot_color : Color = shot_colors[0]

@onready var game_running : bool = false
@onready var high_score : int = 0

func _ready():
	RenderingServer.set_default_clear_color(Color.SKY_BLUE)

func _process(_delta):
	if game_running:
		if draw_timer.is_stopped():
			target_x = null
			gun_pos = null
			queue_redraw()

func clear_tree():
	for n in self.get_children():
		self.remove_child(n)
		n.queue_free()

func new_game():
	clear_tree()
	spawn_player()
	spawn_map(0)
	spawn_map(1)
	spawn_backgrounds()
	spawn_draw_timer()
	game_running = true

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

func spawn_backgrounds():
	var background1_inst = canyon_background.instantiate()
	add_child(background1_inst)

func draw_shot(gun_pos2, target_x2, chamber_slot):
	self.gun_pos = gun_pos2
	self.target_x = target_x2
	self.shot_color = shot_colors[chamber_slot]
	queue_redraw()
	draw_timer.start()
	
func spawn_draw_timer():
	draw_timer = Timer.new()
	draw_timer.wait_time = 0.1
	draw_timer.one_shot = true
	add_child(draw_timer)

func game_over():
	if player.score > high_score:
		high_score = player.score
	var game_over_screen = game_over_menu.instantiate()
	add_child(game_over_screen)

func _draw():
	if target_x and gun_pos:
		draw_line(gun_pos, Vector2(target_x, gun_pos.y), shot_color, 0.5)
		pass
