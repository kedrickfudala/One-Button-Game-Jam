extends Node2D
class_name EnemySpawner

@onready var enemy : PackedScene = preload("res://src/enemy.tscn") 
@onready var player : Object = get_parent()
@onready var world : Object = player.get_parent()
@onready var enemy_speed : float = 20.0

func _ready():
	pass

func spawn_enemy(facing_direction : int, speed_bonus : float):
	var enemy_inst = enemy.instantiate()
	var rng = RandomNumberGenerator.new()
	var random_color = snapped(rng.randf_range(0, 5), 1)
	enemy_inst.global_position = self.global_position
	enemy_inst.speed = min(self.enemy_speed + speed_bonus, 25.0)
	enemy_inst.color_slot = random_color
	get_parent().get_parent().add_child(enemy_inst)
	enemy_inst.facing_direction = facing_direction
