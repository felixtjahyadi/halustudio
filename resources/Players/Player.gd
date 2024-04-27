extends Resource

class_name PlayerResource

@export var name : String = "Player"
@export var texture : Texture2D = preload("res://assets/Player/spritesheets/archie-anim-sheet.png")
@export var defaultHealth : int = 8
var health : int
@export var defaultSpeed : float = 300
var speed : float
@export var defaultArmor : int = 0
var armor : int
@export var weapon : WeaponResource = preload("res://resources/Weapons/Bow.tres")
# TODO : @export var skill : Script

func _ready():
	health = defaultHealth
	speed = defaultSpeed
	armor = defaultArmor

func is_alive():
	return health > 0

# TODO: separate this from PlayerResource
func set_weapon(new_weapon : WeaponResource):
	weapon = new_weapon

func take_hit(value):
	var damageTaken = value - armor
	health -= 1 if damageTaken <= 0 else damageTaken
