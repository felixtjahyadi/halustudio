extends FocusableSkill

class_name ArrowRain

var area_of_effect = load("res://scenes/Skill/area_of_effect.tscn")
var area_scene

func _init():
	cooldown = 5 
	texture = load("res://assets/Skill/skill_image.png")
	description = "Arrow rain"

func activate():
	area_scene.is_place = true
	
func focus():
	area_scene = area_of_effect.instantiate()
	global.player_node.get_parent().add_child(area_scene)
	
func unfocus():
	pass
