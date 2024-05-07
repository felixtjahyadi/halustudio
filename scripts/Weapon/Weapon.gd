extends Node2D

class_name WeaponClass

@export var weapon : WeaponResource = load("res://resources/Weapons/Bow.tres")
@export var rangeToPlayer : float = 20

@export var onFloor: bool = false

@onready var weaponNode : Node2D = $WeaponNode
@onready var weaponSprite : Sprite2D = $WeaponNode/WeaponSprite

@onready var playerDetector: Area2D = $PlayerDetector

## melee ##

## range ##
@onready var projectileScene : PackedScene = load("res://scenes/Weapon_new/Projectiles/Projectile.tscn")
@onready var projectileSpawnPosition: Marker2D = $ProjectileSpawnPosition

var canAttack = true

func _ready():
	print("in ready")
	update_weapon_sprite(weapon)
	
	scale = weapon.scale
	
	var new_transform = Transform2D()
	new_transform.origin = Vector2(rangeToPlayer, 0)
	projectileSpawnPosition.transform = new_transform

	if not onFloor:
		weaponSprite.position.x = rangeToPlayer
		playerDetector.set_collision_mask_value(1, false)
		playerDetector.set_collision_mask_value(2, false)

func _on_player_update_weapon_sprite(weapon):
	self.weapon = weapon
	update_weapon_sprite(weapon)

func update_weapon_sprite(weapon : WeaponResource):
	weaponSprite.texture = weapon.texture
	weaponSprite.rotation = weapon.rotation

func get_input():
	pass

func get_texture():
	return get_node("WeaponNode/WeaponSprite").texture

# attack #
func _process(delta):
	_handle_mouse_direction()
	_handle_attack_input()

func _handle_mouse_direction():
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	handle_mouse_direction(mouse_direction)

func handle_mouse_direction(mouse_direction: Vector2):
	rotation = mouse_direction.angle()
	if scale.y > 0 and mouse_direction.x < 0:
		scale.y *= -1
	elif scale.y < 0 and mouse_direction.x > 0:
		scale.y *= -1

func _handle_attack_input():
	if Input.is_action_pressed("click"):
		attack()

func attack():
	if canAttack:
		_melee_attack() if weapon.type == "melee" else _range_attack()
		_attack_cooldown()

## melee ##
func _melee_attack():
	pass

## melee ##

## range ##
func _range_attack():
	_spawn_projectile()

func _spawn_projectile():
	look_at(get_global_mouse_position())
	var projectile_spawn_position = projectileSpawnPosition.get_global_position()
	
	var projectile_instance = projectileScene.instantiate()
	
	projectile_instance.setup(projectile_spawn_position, weapon.projectileRange)
	projectile_instance.setup_texture(weapon.projectile.texture, weapon.projectile.scale)
	
	projectile_instance.position = projectile_spawn_position
	projectile_instance.rotation_degrees = rotation_degrees
	projectile_instance.apply_impulse(Vector2(weapon.projectileSpeed, 0).rotated(rotation))
	get_tree().get_root().add_child(projectile_instance)

func _attack_cooldown():
	canAttack = false
	await get_tree().create_timer(weapon.attackInterval).timeout
	canAttack = true

## range ##
# attack #

# for pick_up weapon
func _on_player_detector_body_entered(body: CharacterBody2D):
	if body != null:
		playerDetector.set_collision_mask_value(1, false)
		playerDetector.set_collision_mask_value(2, false)
		body.pick_up_weapon(self)
		position = Vector2.ZERO
	else:
		playerDetector.set_collision_mask_value(2, true)
