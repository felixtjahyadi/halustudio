extends Resource

class_name PlayerResource

@export var name : String = "Player"
@export var texture : Texture2D = preload("res://assets/Player/spritesheets/archie-anim-sheet.png")
@export var health : int = 8
@export var speed : float = 300
@export var armor : int = 0
@export var weapon : WeaponResource = preload("res://resources/Weapons/Bow.tres")
# TODO : @export var skill : Script

func _ready():
	pass

func is_alive():
	return health > 0

# TODO: separate this from PlayerResource
func set_weapon(new_weapon : WeaponResource):
	weapon = new_weapon

func take_hit(value):
	var damageTaken = value - armor
	health -= 1 if damageTaken <= 0 else damageTaken
