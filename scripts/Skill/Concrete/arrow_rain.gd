extends FocusableSkill

class_name ArrowRainS

var area_of_effect = load("res://scenes/Skill/area_of_effect.tscn")
var area_scene: Node
var area_duration = 4

func _init():
	cooldown = 5 
	texture = load("res://assets/Skill/skill_image.png")
	description = "Arrow rain"

func activate():
	area_scene.is_place = true
	await global.player_node.get_tree().create_timer(0.1).timeout
	global.player_node.enable_weapon()
	
func focus():
	global.player_node.disable_weapon()
	area_scene = area_of_effect.instantiate()
	area_scene.setup(area_duration)
	global.player_node.get_parent().add_child(area_scene)
	
func unfocus():
	if area_scene and is_instance_valid(area_scene) and not area_scene.is_place:
		area_scene.is_place = false
		area_scene = null
	
	global.player_node.enable_weapon()
