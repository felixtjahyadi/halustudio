extends RigidBody2D

var projectile_range: int
var start_position: Vector2

var hp = 1
var level = 1
var damage = 100
var speed = 100
var knock_back = 100
var size = 1.0

@onready var player = get_tree().get_first_node_in_group("player")

signal remove_from_array(object)

func setup(start: Vector2, range: int):
	projectile_range = range
	start_position = start

func _process(delta):
	handle_bullet_out_of_range()

func handle_bullet_out_of_range():
	if start_position.distance_to(get_global_position()) > projectile_range:
		queue_free()

func _on_body_entered(body):
	var hit_player = body.is_in_group('player')
	if hit_player: return
	
	var hit_tile_map = body is TileMap
	if hit_tile_map: 
		queue_free()
		return
	
	var hit_enemy = body.is_in_group('enemy')
	if hit_enemy:
		# TODO: call enemy get_damage() function
		# Don't forget to set enemy scene's group
		# For now I set it to delete when collide with enemy scene
		queue_free()
