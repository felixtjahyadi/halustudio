extends RigidBody2D

var projectile_range: int
var start_position: Vector2

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
