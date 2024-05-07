extends CharacterBody2D

class_name PlayerClass

signal dead(player: PlayerClass)

@export var player : PlayerResource = preload("res://resources/Players/Archie.tres")

@onready var weapon : Node2D = $Weapon
@onready var weaponSprite : Sprite2D = $Weapon/WeaponNode/WeaponSprite
@onready var playerSprite : Sprite2D = $Sprite2D
@onready var animations : AnimationTree = $AnimationTree

var last_direction = Vector2(0.1, 0.1)

var money = 0
var total_money_collected = 0

func _ready():
	_update_sprite()
	_update_weapon_sprite()
	pass

func _update_sprite():
	playerSprite.texture = player.texture

func _update_weapon_sprite():
	weaponSprite.texture = player.weapon.texture
	weaponSprite.rotation = player.weapon.rotation

func get_damage(value):
	player.take_hit(value)
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
	velocity = direction * player.speed if direction else Vector2.ZERO
	print(player.speed)
	move_and_slide()

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

# hurt box handler
func _on_hurt_box_hurt(damage, angle, knock_back_amount):
	get_damage(damage)
	if player.health <= 0:
		queue_free()

# loot grabber
func _on_grab_area_entered(area):
	if area.is_in_group("loot"):
		area.target = self

func _on_collect_area_entered(area):
	if area.is_in_group("loot"):
		var money_value = area.collect()
		money += money_value
		total_money_collected += money_value

