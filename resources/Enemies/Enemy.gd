extends Resource

class_name EnemyResource

@export var name : String = "Enemy"
@export var texture : Texture2D
@export var dead_texture : Texture2D
@export var attack_texture : Texture2D
@export var health : int = 10
@export var speed : float = 250
@export var armor : int = 1

var initial_health : int
var initial_speed : float
var initial_armor : int

func setup():
	initial_health = health
	initial_speed = speed
	initial_armor = armor
	return self

func reset():
	health = initial_health
	speed = initial_speed
	armor = initial_armor

func is_alive():
	return health > 0

func take_hit(value):
	var damageTaken = value - armor
	health -= 1 if damageTaken <= 0 else damageTaken
