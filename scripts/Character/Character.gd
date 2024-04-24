extends CharacterBody2D

class_name Character

@export var weapon_scene: PackedScene
@export var speed = 300.0

var current_weapon: Node

func set_weapon():
	pass
	
func attack():
	pass

func _physics_process(delta):
	move()

func move():
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed if direction else Vector2.ZERO
	move_and_slide()
