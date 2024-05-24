extends Skill

@export var immune_duration = 2

func _init():
	cooldown = 10
	texture = load("res://assets/Player/skill-icon/morin-immunity.png")
	skill_name = "Immune"
	description = "Temporarily becomes invulnerable to all damage."

func activate():
	global.player_node.is_immune = true
	await global.player_node.get_tree().create_timer(immune_duration).timeout
	global.player_node.is_immune = false
