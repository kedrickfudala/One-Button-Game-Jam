extends CharacterBody2D
class_name Enemy

@onready var score_popup : PackedScene = preload("res://src/interface/score_popup.tscn")

@onready var sprite : Object = $Sprite2D
@onready var animation_player : Object = $AnimationPlayer
@onready var hitbox : Object = $Hitbox
@onready var hurtbox : Object = $Hurtbox
@onready var score_timer :Object = $ScoreTimer
@onready var label : Object = $CanvasLayer/Label

@onready var facing_direction : int = 0
@onready var animate : int = 1
@onready var flip : int = 1
@onready var flip_enemy : int = 0
@onready var speed : float

@onready var stab : bool = false
@onready var can_stab : bool = true

@onready var colors : Array = [Color.RED, Color.ORANGE, Color.YELLOW, Color.GREEN, Color.DEEP_SKY_BLUE, Color.PURPLE]
@onready var color_slot : int

func _ready():
	sprite.modulate = colors[color_slot]
	label.modulate = colors[color_slot]
	score_timer.wait_time = 3
	score_timer.one_shot = true
	label.visible = false
	
	
func _physics_process(_delta):
	if facing_direction != 0 and flip:
		flip_enemy = facing_direction
	if flip_enemy < 0:
		self.scale.x *= -1
		label.scale.x *= -1
		flip_enemy = 0
		flip = 0
	move()

func move():
	if stab == false and can_stab == true:
		animation_player.play("walk")
		velocity = Vector2(speed * facing_direction, 0)
		move_and_slide()
	else:
		animation_player.play("stab")
		
func die(killScore):
	can_stab = false
	sprite.visible = false
	hurtbox.queue_free()
	label.text = "+" + str(killScore)
	label.visible = true
	score_timer.start()
	await get_tree().create_timer(3).timeout
	self.queue_free()
	#var popup_inst = score_popup.instantiate()
	##pup_inst.global_position = self.global_position
	#get_parent().add_child(popup_inst)
	#popup_inst.label.global_position = self.global_position


