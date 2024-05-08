extends Area2D

var level = 1
var speed = 100
@export var damage = 100
var knock_back = 100
var size = 1.0

var target = Vector2.ZERO
var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("player")

func _ready():
	speed = 100
	damage = damage
	knock_back = 100
	size = 1.0
