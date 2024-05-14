extends Resource

class_name PlayerResource

@export var name : String = "Player"
@export var texture : Texture2D = preload("res://assets/Player/spritesheets/archie/archie-anim-sheet.png")
@export var health : int = 8 
@export var speed : float = 300
@export var armor : int = 0
@export var weapon : WeaponResource = preload("res://resources/Weapons/Bow.tres")
@export var art: Texture2D
@export var avatar: Texture2D
@export var cooldown: int
# TODO?? : @export var skill : Script

var initial_health : int
var initial_speed : float
var initial_armor : int
var initial_weapon : WeaponResource 

func setup():
	initial_health = health
	initial_speed = speed
	initial_armor = armor
	initial_weapon = weapon
	return self

func reset():
	health = initial_health
	speed = initial_speed
	armor = initial_armor
	weapon = initial_weapon

func is_alive():
	return health > 0

func set_weapon(new_weapon : WeaponResource):
	weapon = new_weapon

func take_hit(value):
	var damageTaken = value - armor
	health -= 1 if damageTaken <= 0 else damageTaken
