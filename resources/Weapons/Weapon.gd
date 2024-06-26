extends Resource

class_name WeaponResource

@export var name : String = "Weapon"
@export var texture : Texture2D = preload("res://assets/Weapons/bow.png")
@export var baseDamage : float = 1.2
@export var attackInterval : float = 1.2
@export var attackCount : int = 1
@export_enum("range", "melee") var type : String = "range"

@export_group("Rarity")
@export_enum("common:1", "uncommon:2", "rare:3", "epic:4", "legendary:5") var rarity : int = 1
@export var damageBonus : float = 1.2

@export_group("Transform")
@export_range(-360, 360) var rotation : float = 0
@export var scale : Vector2 = Vector2(2, 2)

@export_group("Range Properties")
@export var projectile : ProjectileResource = preload("res://resources/Projectiles/Arrow.tres")
@export var projectileScale : Vector2 = Vector2(1, 1)
@export var projectileSpeed : float = 1000.0
@export var projectileRange : float = 600.0
@export var passEnemy : bool = false
@export var maxAmmo : int = 10
@export var ammo : int = 10

@export_group("Melee Properties")
@export_enum("slash", "wide slash") var attackType : String = "slash"
@export var attackScale : float = 1

var damage_multiplier: float = 1
var projectile_speed_multiplier: float = 1
var weapon_enabled: float = true
var trail: PackedScene = load("res://scenes/Particle/projectile_trail.tscn")
var trail_enable = false

func get_damage():
	return (baseDamage + (damageBonus * rarity)) * damage_multiplier
	
func reset():
	damage_multiplier = 1
	projectile_speed_multiplier = 1
	trail_enable = false
