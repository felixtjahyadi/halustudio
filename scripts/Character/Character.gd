extends CharacterBody2D

class_name Character

signal dead(character: Character)

@export var health = 10
@export var speed = 300
@export var armor = 2
@export var weapon_scene: PackedScene

var current_weapon: Node
var current_health = health
var current_armor = armor
var is_alive = true

func set_weapon():
	pass
	
func attack():
	pass
	
func get_damage(value):
	# When character is dead emit this signal
	dead.emit(self)
	pass

# Movement
func _physics_process(delta):
	move()
	if Input.is_action_just_pressed("test"):
		dead.emit(self)

func move():
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed if direction else Vector2.ZERO
	move_and_slide()

# Character Basic Animation
@onready var animations = $AnimationTree

var last_direction = Vector2(0.1, 0.1)

func _process(delta):
	set_animation()

func set_animation():
	set_walking()
	set_blend_position()

func set_walking():
	var direction = Input.get_vector("left", "right", "up", "down")
	var is_walking = direction != Vector2.ZERO
	animations["parameters/conditions/is_walking"] = is_walking
	animations["parameters/conditions/idle"] = not is_walking
	
	if is_walking and direction.x != 0: last_direction = direction

func set_blend_position():
	animations["parameters/Idle/blend_position"] = last_direction.x
	animations["parameters/Walk/blend_position"] = last_direction.x

func _on_hurt_box_hurt(damage, angle, knock_back_amount):
	print(damage)
	get_damage(damage)
	if health <= 0:
		queue_free()
