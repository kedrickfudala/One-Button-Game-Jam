extends CharacterBody2D
class_name Player

@onready var sprite : Object = $Sprite2D
@onready var input_timer : Object = $InputTimer
@onready var map_detect : Object = $MapDetect
@onready var animation_player : Object = $AnimationPlayer
@onready var enemy_spawner1 : Object = $EnemySpawner1
@onready var enemy_spawner2 : Object = $EnemySpawner2
@onready var chamber_sprite : Object = $ChamberSprite
@onready var enemy_spawn_timer : Object = $EnemySpawnTimer
@onready var hurtbox : Object = $Hurtbox

@onready var chamber = ["RED", "ORANGE", "YELLOW", "GREEN", "BLUE", "PURPLE"]
@onready var chamber_slot : float = 0.0
@onready var chamber_spin : float = 0.0

@onready var hearts : int = 3
@onready var facing_direction : int = 1
@onready var speed : int = 15

@onready var raycast = $Gun/RayCast2D
@onready var enemy = get_parent().get_node("Enemy")



func _ready():
	input_timer.wait_time = 0.1
	input_timer.one_shot = true
	enemy_spawn_timer.wait_time = 4
	enemy_spawn_timer.one_shot = true

func _physics_process(delta):
	take_input()
	move()
	update_animations()
	
	spawn_enemies()
	print(raycast.is_colliding())
func fire():
	chamber_slot = fmod(snapped(chamber_slot, 1), 6)
	chamber_spin = 0
	print("CSLOT " + str(chamber_slot) + " CSPIN " + str(chamber_spin))
	print("FIRE " + str(chamber[chamber_slot]))
	if(raycast.is_colliding()):
		var hit_collider = raycast.get_collider()
		print(hit_collider)
		if hit_collider.name == enemy:
			print("enemy killed")

func take_input():
	if get_global_mouse_position().x > self.global_position.x:
		facing_direction = 1
	else:
		facing_direction = -1

	if Input.is_action_just_pressed("ui_accept"):
		chamber_sprite.rotation_degrees = fmod(chamber_sprite.rotation_degrees, 360)
		input_timer.start()
	if Input.is_action_pressed("ui_accept"):
		chamber_spin += 0.1
		print("CSLOT " + str(chamber_slot) + " CSPIN " + str(chamber_spin))
		if input_timer.is_stopped():
			var tween = create_tween()
			tween.tween_property(chamber_sprite, "rotation_degrees", snapped(chamber_slot + snapped(chamber_spin, 0.1), 1) * 60, 0.1)
	if Input.is_action_just_released("ui_accept"):
		chamber_slot = fmod(snapped(chamber_slot, 1), 6)
		if !input_timer.is_stopped(): #Tap fire
			fire()
		else: #Hold spin and fire
			chamber_slot += fmod(snapped(chamber_spin, 0.1), 6)
			fire()

func move():
	velocity = Vector2(speed * facing_direction, 0)
	move_and_slide()

func update_animations():
	if facing_direction < 0:
		sprite.flip_h = 1
	elif facing_direction > 0:
		sprite.flip_h = 0
		
func spawn_enemies():
	if enemy_spawn_timer.is_stopped():
		var rng = RandomNumberGenerator.new()
		var random_number = snapped(rng.randf_range(0, 1), 1)
		if random_number == 0:
			enemy_spawner1.spawn_enemy(1)
		else:
			enemy_spawner2.spawn_enemy(-1)
		enemy_spawn_timer.start()
