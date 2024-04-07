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
@onready var score_label : Object = $ScoreLabel
@onready var raycast : Object = $Sprite2D/Gun/RayCast2D
@onready var gun : Object = $Sprite2D/Gun
@onready var world : Object = get_parent()

@onready var chamber : Array = ["RED", "ORANGE", "YELLOW", "GREEN", "BLUE", "PURPLE"]
@onready var chamber_slot : float = 0.0
@onready var chamber_spin : float = 0.0

@onready var hearts : int = 3
@onready var facing_direction : int = 1
@onready var current_direction : int = 1
@onready var alive : int = 1
@onready var speed : int = 15

@onready var score : int = 0
@onready var combo : int = 0

func _ready():
	input_timer.wait_time = 0.1
	input_timer.one_shot = true
	enemy_spawn_timer.wait_time = 4
	enemy_spawn_timer.one_shot = true

func _physics_process(delta):
	if alive == 1:
		animation_player.play("walk")
		alive_process()
	else:
		animation_player.play("dead")
		gun.visible = false

func alive_process():
	if sprite.frame == 1:
		if facing_direction == 1:
			gun.position.y = -1
		else:
			gun.position.y = -2
	if sprite.frame == 2:
		if facing_direction == 1:
			gun.position.y = -2
		else:
			gun.position.y = -3
		
	if get_global_mouse_position().x > self.global_position.x:
		current_direction = 1
	else:
		current_direction = -1
	if current_direction != facing_direction:
		update_animations()
	take_input()
	move()
	update_score()
	spawn_enemies()

func fire():
	chamber_slot = fmod(snapped(chamber_slot, 1), 6)
	chamber_spin = 0
	#print("CSLOT " + str(chamber_slot) + " CSPIN " + str(chamber_spin))
	print("FIRE " + str(chamber[chamber_slot]))
	var enemy_hurtbox = raycast.get_collider()
	if enemy_hurtbox != null:
		var enemy = enemy_hurtbox.get_parent()
		world.draw_shot(gun.global_position, enemy.global_position.x, chamber_slot)
		queue_redraw()
		if self.chamber_slot == enemy.color_slot:
			enemy.die()

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
		#print("CSLOT " + str(chamber_slot) + " CSPIN " + str(chamber_spin))
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
		sprite.scale.x = 1
	elif facing_direction > 0:
		sprite.scale.x = -1
		
func update_score():
	score_label.text = "Score: " + str(score)

func spawn_enemies():
	if enemy_spawn_timer.is_stopped():
		var rng = RandomNumberGenerator.new()
		var random_number = snapped(rng.randf_range(0, 1), 1)
		print(random_number)
		if random_number == 0:
			enemy_spawner1.spawn_enemy(1)
		else:
			enemy_spawner2.spawn_enemy(-1)
		enemy_spawn_timer.start()
		
func _on_hurtbox_area_entered(area):
	var enemy = area.get_parent()
	enemy.stab = true
	alive = 0
