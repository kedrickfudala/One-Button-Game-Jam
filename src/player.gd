extends CharacterBody2D
class_name Player

@onready var sprite : Object = $Sprite2D
@onready var input_timer : Object = $InputTimer
@onready var map_area : Object = $MapArea
@onready var animation_player : Object = $AnimationPlayer
@onready var enemy_spawner1 : Object = $EnemySpawner1
@onready var enemy_spawner2 : Object = $EnemySpawner2
@onready var chamber_sprite : Object = $ChamberSprite

@onready var chamber = ["RED", "ORANGE", "YELLOW", "GREEN", "BLUE", "PURPLE"]
@onready var chamber_slot : float = 0.0
@onready var chamber_spin : float = 0.0

@onready var hearts : int = 3
@onready var facing_direction : int = 1
@onready var speed : int = 15

func _ready():
	input_timer.wait_time = 0.15
	input_timer.one_shot = true

func _physics_process(delta):
	take_input()
	move()
	update_animations()

func take_input():
	if get_global_mouse_position().x > self.global_position.x:
		facing_direction = 1
	else:
		facing_direction = -1
	
	if Input.is_action_just_pressed("ui_accept"):
		input_timer.start()
	if Input.is_action_pressed("ui_accept"):
		chamber_spin += 0.05
		if chamber_spin > 6:
			chamber_spin -= 6
	if Input.is_action_just_released("ui_accept"):
		if !input_timer.is_stopped():
			print("Tap!")
			print("FIRE " + str(chamber[chamber_slot]))
			chamber_spin = 0
		else:
			chamber_slot += snapped(chamber_spin, 1) #floor(chamber_spin)
			print(chamber_slot)
			if chamber_slot > 5:
				chamber_slot -= 5
			print("Hold!")
			print("FIRE " + str(chamber[chamber_slot]))
			chamber_spin = 0
	
	chamber_sprite.rotation_degrees = (chamber_slot * -60) + (chamber_spin * -60)

func move():
	velocity = Vector2(speed * facing_direction, 0)
	move_and_slide()

func update_animations():
	if facing_direction < 0:
		sprite.flip_h = 1
	elif facing_direction > 0:
		sprite.flip_h = 0
