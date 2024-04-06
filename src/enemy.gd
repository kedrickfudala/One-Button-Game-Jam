extends CharacterBody2D
class_name Enemy

@onready var sprite : Object = $Sprite2D
@onready var animation_olayer : Object = $AnimationPlayer
@onready var hitbox_area : Object = $HitboxArea
@onready var hitbox : Object = $HitboxArea/Hitbox

@onready var facing_direction : int = 0

func _ready():
	pass
	
func _physics_process(delta):
	pass

func die():
	self.queue_free()
