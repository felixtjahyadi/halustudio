extends RangeCharacter

@onready var weapon: Node2D = get_node("Weapon")

func _process(delta):
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	weapon.rotation = mouse_direction.angle()
	if weapon.scale.y == 2 and mouse_direction.x<0:
		weapon.scale.y = -2
	elif weapon.scale.y == -2 and mouse_direction.x>0:
		weapon.scale.y = 2
