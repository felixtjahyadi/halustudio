extends Skill

class_name Immune

@export var immune_duration = 1

func _init():
	cooldown = 10
	texture = load("res://assets/Skill/skill_image.png")
	description = "Immune Skill"

func activate():
	global.player_node.is_immune = true
	await global.player_node.get_tree().create_timer(immune_duration).timeout
	global.player_node.is_immune = false
