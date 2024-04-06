extends CharacterBody2D
class_name Enemy

@onready var sprite : Object = $Sprite2D
@onready var animation_olayer : Object = $AnimationPlayer
@onready var hitbox_area : Object = $HitboxArea
@onready var hitbox : Object = $HitboxArea/Hitbox

@onready var facing_direction : int = 0
@onready var speed : int = 5

func _ready():
	pass
	
func _physics_process(delta):
	pass

func move():
	velocity = Vector2(speed * facing_direction, 0)
	move_and_slide()

func die():
	self.queue_free()
