extends CharacterBody2D
class_name Player

@onready var sprite : Object = $Sprite2D
@onready var input_timer : Object = $InputTimer
@onready var chamber_cycle : Object = $ChamberCycle
@onready var map_area : Object = $MapArea
@onready var map_frame : Object = $MapArea/MapFrame
@onready var animation_player : Object = $AnimationPlayer
@onready var enemy_spawner1 : Object = $EnemySpawner1
@onready var enemy_spawner2 : Object = $EnemySpawner2

@onready var chamber = ["RED", "ORA", "YEL", "GRE", "BLU", "PUR"]
@onready var chamber_slot : float = 0.0
@onready var hearts : int = 3
@onready var facing_direction : int = 1
@onready var speed : int = 15

func _ready():
	input_timer.wait_time = 0.3
	input_timer.one_shot = true
	chamber_cycle.wait_time = 6

func _physics_process(delta):
	take_input()
	move()
	update_animations()

func take_input():
	var previous_slot = chamber_slot
	if Input.is_action_just_pressed("ui_accept"):
		input_timer.start()
	if Input.is_action_pressed("ui_accept"):
		chamber_slot += 0.1
		if chamber_slot > 6:
			chamber_slot -= 6
	if Input.is_action_just_released("ui_accept"):
		if !input_timer.is_stopped():
			print("Tap!")
			chamber_slot = previous_slot
			facing_direction *= -1
		else:
			print("Hold!")
			chamber_slot = floor(chamber_slot)
			print("FIRE " + str(chamber[chamber_slot]))

func move():
	velocity = Vector2(speed * facing_direction, 0)
	move_and_slide()

func update_animations():
	if facing_direction < 0:
		sprite.flip_h = 1
	elif facing_direction > 0:
		sprite.flip_h = 0
