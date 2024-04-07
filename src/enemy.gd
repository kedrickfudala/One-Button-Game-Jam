extends CharacterBody2D
class_name Enemy

@onready var sprite : Object = $Sprite2D
@onready var animation_player : Object = $AnimationPlayer
@onready var hitbox : Object = $Hitbox
@onready var hurtbox : Object = $Hurtbox

@onready var facing_direction : int = 0
@onready var animate : int = 1
@onready var flip : int = 1
@onready var flip_enemy : int = 0
@onready var speed : int = 20

@onready var stab : bool = false

@onready var colors : Array = [Color.RED, Color.ORANGE, Color.YELLOW, Color.GREEN, Color.DEEP_SKY_BLUE, Color.PURPLE]
@onready var color_slot : int

func _ready():
	sprite.modulate = colors[color_slot]
	pass
	
func _physics_process(delta):
	if facing_direction != 0 and flip:
		flip_enemy = facing_direction
	if flip_enemy < 0:
		self.scale.x *= -1
		flip_enemy = 0
		flip = 0
	move()

func move():
	if stab == false:
		animation_player.play("walk")
		velocity = Vector2(speed * facing_direction, 0)
		move_and_slide()
	else:
		animation_player.play("stab")
		
func die():
	self.queue_free()
