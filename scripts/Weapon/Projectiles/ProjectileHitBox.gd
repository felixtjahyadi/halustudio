extends Area2D

var level = 1
var hp = 1
var speed = 100
@export var damage = 100
var knock_back = 100
var size = 1.0

var target = Vector2.ZERO
var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")

signal remove_from_array(object)

func _ready():
	hp = 1
	speed = 100
	damage = damage
	knock_back = 100
	size = 1.0

func enemy_hit(charge = 1):
	hp -= charge
	if hp <= 0:
		emit_signal("remove_from_array", self)
		queue_free()
