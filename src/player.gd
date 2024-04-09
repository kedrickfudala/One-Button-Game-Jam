extends CharacterBody2D
class_name Player

@onready var sprite : Object = $Sprite2D
@onready var input_timer : Object = $InputTimer
@onready var rate_decrease_timer : Object = $RateDecreaseTimer
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
@onready var gun_sprite : Object = $Sprite2D/Gun/Sprite2D
@onready var particles : Object = $Sprite2D/GPUParticles2D
@onready var draw_timer : Object = $DrawTimer
@onready var death_particles : Object = $Sprite2D/DeathParticles
@onready var world : Object = get_parent()
@onready var label : Object = $Label
@onready var powerup_area : Object = $PowerupArea

@onready var colors : Array = [Color.RED, Color.ORANGE, Color.YELLOW, Color.GREEN, Color.DEEP_SKY_BLUE, Color.PURPLE]
@onready var chamber : Array = ["RED", "ORANGE", "YELLOW", "GREEN", "BLUE", "PURPLE"]
@onready var chamber_slot : float = 0.0
@onready var chamber_spin : float = 0.0

@onready var facing_direction : int = 1
@onready var current_direction : int = 1
@onready var alive : int = 1
@onready var powered : bool = false
@onready var power_time : int = 0
@onready var speed : int = 15
@onready var color_cycle : int = 0

@onready var base_score : int = 100
@onready var score : int = 0
@onready var combo : int = 1
@onready var enemy_spawn_count : float = 0.0

@onready var init_spawn_rate : float = 3.5 #the amount of time it takes for enemies to spawn at the start of the game
@onready var spawn_rate_increase : float = 0.1 #the increase in spawn rate per enemy spawned
@onready var min_spawn_time : float = 1.0 #the minimum amount of time it takes for an enemy to spawn
@onready var enemy_speed_rate : float = 5 #the increase in enemy speed. higher numbers means it takes longer to ramp up in speed

func _ready():
	rate_decrease_timer.wait_time = 10
	rate_decrease_timer.one_shot = true
	input_timer.wait_time = 0.1
	input_timer.one_shot = true
	enemy_spawn_timer.wait_time = init_spawn_rate
	enemy_spawn_timer.one_shot = true
	draw_timer.wait_time = 0.1
	draw_timer.one_shot = true
	death_particles.emitting = false
	label.visible = false

func _physics_process(_delta):
	if alive == 1:
		animation_player.play("walk")
		alive_process()
	else:
		animation_player.play("dead")
		gun.visible = false
	
	if draw_timer.is_stopped():
		particles.emitting = false
	else:
		particles.emitting = true

func alive_process():
	if powered:
		var tween = create_tween()
		tween.tween_property(gun_sprite, "modulate", colors[color_cycle], .1)
		color_cycle += 1
		if color_cycle == 6:
			color_cycle = 0
	else:
		gun_sprite.modulate = Color.WHITE
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
		particles.modulate = colors[chamber_slot]
		draw_timer.start()
		if powered:
			var rng = RandomNumberGenerator.new()
			var random_number = snapped(rng.randf_range(0, 9), 1)
			if random_number == 0:
				world.spawn_powerup(enemy)
			combo += 1
			var killScore = (base_score * (0.5 * combo))
			score += killScore
			enemy.die(killScore)
		elif self.chamber_slot == enemy.color_slot:
			var rng = RandomNumberGenerator.new()
			var random_number = snapped(rng.randf_range(0, 9), 1)
			if random_number == 0:
				world.spawn_powerup(enemy)
			combo += 1
			var killScore = (base_score * (0.5 * combo))
			score += killScore
			enemy.die(killScore)
			
		else:
			combo = 1
		particles.emitting = false
	else:
		combo = 1
		if facing_direction == 1:
			world.draw_shot(gun.global_position, 10000, chamber_slot)
			particles.modulate = colors[chamber_slot]
			draw_timer.start()
		else:
			world.draw_shot(gun.global_position, -10000, chamber_slot)
			particles.modulate = colors[chamber_slot]
			draw_timer.start()
	
	if combo % 10 == 0:
		base_score += 50
		var combo_text = str((combo)/2)
		label.text = "x" + combo_text + " Combo!" + "\nBase Score +50"
		label.visible = true
		await get_tree().create_timer(3).timeout
		label.visible = false
		
		

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
	if combo == 1:
		score_label.text = "Score: " + str(score) + "\n\nCombo: x" + str(1)
	else:
		score_label.text = "Score: " + str(score) + "\n\nCombo: x" + str(combo / 2.0)

func spawn_enemies():
	if rate_decrease_timer.is_stopped():
		if enemy_spawn_timer.wait_time > min_spawn_time:
			enemy_spawn_timer.wait_time -= spawn_rate_increase
			print(enemy_spawn_timer.wait_time)
		rate_decrease_timer.start()
	if enemy_spawn_timer.is_stopped():
		var rng = RandomNumberGenerator.new()
		var random_number = snapped(rng.randf_range(0, 1), 1)
		enemy_spawn_count += 1
		if random_number == 0:
			enemy_spawner1.spawn_enemy(1, enemy_spawn_count / enemy_speed_rate)
		else:
			enemy_spawner2.spawn_enemy(-1, enemy_spawn_count / enemy_speed_rate)
		enemy_spawn_timer.start()

func die():
	alive = 0
	death_particles.emitting = true
	world.game_over()

func _on_hurtbox_area_entered(area):
	var enemy = area.get_parent()
	if enemy.can_stab:
		enemy.stab = true
		var tween = create_tween()
		tween.tween_property(sprite, "modulate", colors[enemy.color_slot], 1)
		if alive:
			die()


func _on_powerup_area_area_entered(area):
	var powerup = area.get_parent()
	if powered == true:
		power_time += 15
		powerup.queue_free()
		return
	powerup.queue_free()
	powered = true
	power_time += 15
	while power_time != 0:
		await get_tree().create_timer(1).timeout
		power_time -= 1
		print(power_time)
	powered = false
	
