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
@onready var temp_spin : float = 0.0

@onready var hearts : int = 3
@onready var facing_direction : int = 1
@onready var speed : int = 15

func _ready():
	input_timer.wait_time = 0.15
	input_timer.one_shot = true

func _physics_process(delta):
	take_input(delta)
	move()
	update_animations()

func fire():
	chamber_slot = fmod(snapped(chamber_slot, 1), 6)
	chamber_spin = 0
	print("CSLOT " + str(chamber_slot) + " CSPIN " + str(chamber_spin))
	print("FIRE " + str(chamber[chamber_slot]))
	#var tween2 = create_tween()
	#tween2.tween_property(self, "chamber_spin", 0, 0.1)
	pass

func take_input(delta):
	if get_global_mouse_position().x > self.global_position.x:
		facing_direction = 1
	else:
		facing_direction = -1

	if Input.is_action_just_pressed("ui_accept"):
		#chamber_slot = fmod(snapped(chamber_slot, 1), 6)
		chamber_sprite.rotation_degrees = fmod(chamber_sprite.rotation_degrees, 360)
		input_timer.start()
	if Input.is_action_pressed("ui_accept"):
		chamber_spin += 0.1
		#chamber_spin = fmod(snapped(chamber_spin, 0.1), 6)
		#print(chamber_spin)
		print("CSLOT " + str(chamber_slot) + " CSPIN " + str(chamber_spin))
		#print(chamber_sprite.rotation_degrees)
		if !input_timer.is_stopped():
			#chamber_sprite.rotation_degrees = (chamber_slot) * 60
			pass
		else:
			var tween3 = create_tween()
			#chamber_slot = fmod(snapped(chamber_slot, 1), 6)
			
			tween3.tween_property(chamber_sprite, "rotation_degrees", snapped(chamber_slot + snapped(chamber_spin, 0.1), 1) * 60, 0.1)
			
			#tween3.tween_property(chamber_sprite, "rotation_degrees", fmod(snapped(chamber_slot + fmod(snapped(chamber_spin, 0.1), 6), 1), 6) * 60, 0.1)
			#if (chamber_sprite.rotation_degrees == 360):
				#chamber_sprite.rotation_degrees = 0
				
				
			#tween3.tween_property(chamber_sprite, "rotation_degrees", (chamber_slot + snapped(fmod(chamber_spin, 6), 0.1)) * 60, 0.1)
			#chamber_sprite.rotation_degrees = (chamber_slot + fmod(snapped(chamber_spin, 0.1), 6)) * 60
	if Input.is_action_just_released("ui_accept"):
		chamber_slot = fmod(snapped(chamber_slot, 1), 6)
		#if chamber_slot > 5:
			#chamber_slot -= 5
		if !input_timer.is_stopped(): #Tap fire
			fire()
		else: #Hold spin and fire
			chamber_slot += fmod(snapped(chamber_spin, 0.1), 6)
			#var tween = create_tween()
			#tween.tween_property(self, "chamber_slot", chamber_slot + fmod(snapped(chamber_spin, 0.1), 6), 0.5)
			#tween.tween_property(self, "chamber_slot", snapped(fmod(chamber_slot + chamber_spin, 6), 1), 0.5)
			fire()

	
	#chamber_slot = snapped(fmod(chamber_slot, 5), 1)
	#if Input.is_action_just_pressed("ui_accept"):
		#input_timer.start()
	#if Input.is_action_pressed("ui_accept"):
		#chamber_spin += 0.1
		#if chamber_spin > 6:
			#chamber_spin -= 6
	#if Input.is_action_just_released("ui_accept"): 
		#if !input_timer.is_stopped(): #Tap fire
			#chamber_slot = snapped(fmod(chamber_slot, 5), 1)
			#print("FIRE " + str(chamber[chamber_slot]))
			#var tween2 = create_tween()
			#tween2.tween_property(self, "chamber_spin", 0, 0.1)
		#else: #Hold spin and fire
			#chamber_slot = snapped(fmod(chamber_slot, 5), 1)
			#var tween = create_tween()
			#tween.tween_property(self, "chamber_slot", chamber_slot + snapped(chamber_spin, 1), 0.5)
			#chamber_slot = snapped(fmod(chamber_slot, 5), 1)
			##print(chamber_slot)
			#print("FIRE " + str(chamber[chamber_slot]))
			#var tween2 = create_tween()
			#tween2.tween_property(self, "chamber_spin", 0, 0.5)
	#if input_timer.is_stopped():
		#var tween3 = create_tween()
		#tween3.tween_property(chamber_sprite, "rotation_degrees", (chamber_slot + chamber_spin) * 60, 0.1)
		##chamber_sprite.rotation_degrees = (chamber_slot + chamber_spin) * 60
	#else:
		#chamber_sprite.rotation_degrees = (chamber_slot) * 60
	##print(chamber_sprite.rotation_degrees)
	#print(chamber_slot)

func move():
	#velocity = Vector2(speed * facing_direction, 0)
	move_and_slide()

func update_animations():
	if facing_direction < 0:
		sprite.flip_h = 1
	elif facing_direction > 0:
		sprite.flip_h = 0
