extends Resource

class_name EnemyResource

@export var name : String = "Enemy"
@export var texture : Texture2D
@export var attackTexture : Texture2D
@export var health : int = 10
@export var speed : float = 250
@export var armor : int = 1
@export var baseDamage : int = 1
@export var detectionRadius : float = 200.0
@export var knock_back_recovery : float = 3.5
@export var max_coins : int = 6
@export var money : int = 2

var initial_health : int
var initial_speed : float
var initial_armor : int
var initial_damage : int

func setup():
	initial_health = health
	initial_speed = speed
	initial_armor = armor
	initial_damage = baseDamage
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
