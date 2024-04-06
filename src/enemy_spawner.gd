extends Node2D
class_name EnemySpawner

@onready var enemy : PackedScene = preload("res://src/enemy.tscn") 
@onready var player : Object = get_parent()
@onready var world : Object = player.get_parent()

func _ready():
	print(player.hearts)

func spawn_enemy(facing_direction : int):
	var enemy_inst = enemy.instantiate()
	enemy_inst.global_position = self.global_position

	get_parent().get_parent().add_child(enemy_inst)
	enemy_inst.facing_direction = facing_direction
