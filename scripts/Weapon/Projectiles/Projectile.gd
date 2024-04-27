extends RigidBody2D

var projectile_range: int
var start_position: Vector2

func setup(start: Vector2, max_range: int):
	projectile_range = max_range
	start_position = start

func setup_texture(new_texture: Texture2D, new_scale: Vector2):
	$ProjectileSprite.texture = new_texture
	$ProjectileSprite.scale = new_scale

func _process(_delta):
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
