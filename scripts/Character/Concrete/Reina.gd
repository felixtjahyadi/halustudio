extends RangeCharacter

var money = 0
var total_money_collected = 0

@onready var weapon: Node2D = get_node("Weapon")

func _process(delta):
	var mouse_direction: Vector2 = (get_global_mouse_position() - global_position).normalized()
	weapon.rotation = mouse_direction.angle()
	if weapon.scale.y == 2 and mouse_direction.x<0:
		weapon.scale.y = -2
	elif weapon.scale.y == -2 and mouse_direction.x>0:
		weapon.scale.y = 2

func _on_grab_area_entered(area):
	if area.is_in_group("loot"):
		area.target = self

func _on_collect_area_entered(area):
	if area.is_in_group("loot"):
		var money_value = area.collect()
		money += money_value
		total_money_collected += money_value
