extends Resource

class_name Player

@export var name : String = "Player"
@export var textures : Dictionary = {
	"idle_left": preload("res://assets/Player/spritesheets/archie-idle-anim-sheet-flip.png"),
	"idle_right": preload("res://assets/Player/spritesheets/archie-idle-anim-sheet.png"),
	"walk_left": preload("res://assets/Player/spritesheets/archie-walk-anim-sheet-flip.png"),
	"walk_right": preload("res://assets/Player/spritesheets/archie-walk-anim-sheet.png"),
}
@export var defaultHealth : int = 8
var health : int
@export var defaultSpeed : float = 300
var speed : float
@export var defaultArmor : int = 0
var armor : int
@export var weapon : Weapon = preload("res://resources/Weapons/Bow.tres")
# TODO : @export var skill : Script

func _ready():
	health = defaultHealth
	speed = defaultSpeed
	armor = defaultArmor

func is_alive():
	return health > 0

func set_weapon(new_weapon : Weapon):
	weapon = new_weapon

func take_hit(value):
	var damageTaken = value - armor
	health -= 1 if damageTaken <= 0 else damageTaken
