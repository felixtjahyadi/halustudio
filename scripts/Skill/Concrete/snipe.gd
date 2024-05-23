extends FocusableSkill

class_name Snipe

var marker = load("res://scenes/Skill/sniper_marker.tscn")
var marker_scene: Node

var damage_multiplier: float = 3
var projectile_speed_multiplier: float = 0.5

func _init():
	cooldown = 5 
	texture = load("res://assets/Skill/skill_image.png")
	description = "Snipe Skill"

func activate():
	global.player_node.enable_weapon()
	marker_scene.is_place = true
	
	await global.player_node.get_tree().create_timer(0.1).timeout
	
	var weapon = global.player_node.get_weapon()
	weapon.reset()
	
func focus():
	global.player_node.disable_weapon()
	
	var weapon = global.player_node.get_weapon()
	weapon.damage_multiplier = damage_multiplier
	weapon.projectile_speed_multiplier = projectile_speed_multiplier
	weapon.trail_enable = true
	
	marker_scene = marker.instantiate()
	global.player_node.get_parent().add_child(marker_scene)
	
func unfocus():
	if marker_scene and is_instance_valid(marker_scene) and not marker_scene.is_place:
		marker_scene.is_place = false
		marker_scene = null
	
	var weapon = global.player_node.get_weapon()
	weapon.reset()
	global.player_node.enable_weapon()
