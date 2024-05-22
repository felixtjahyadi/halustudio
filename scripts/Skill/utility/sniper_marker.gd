extends Marker2D

@onready var sprite = $Sprite2D

var is_place = false:
	set(value):
		is_place = value
		queue_free()

func _physics_process(delta):
	if not is_place:
		queue_redraw()
		sprite.global_position = get_global_mouse_position()

func _draw():
	var projectileOffset = global.player_node.find_child('ProjectileSpawnPosition')
	draw_line(projectileOffset.global_position, get_global_mouse_position(), Color.RED, 4)
