extends Skill

class_name Dash

@export var immune_duration = 1
@export var dash_duration = 0.2
@export var damage_duration = 2
@export var damage_multiplier = 2

var dash_ghost_node = load("res://scenes/Skill/dash_ghost.tscn")

func _init():
	cooldown = 5
	texture = load("res://assets/Player/skill-icon/wade-dashnslash.png")
	skill_name = "Dash"
	description = "Swiftly dashes through enemies and temporarily immune."

func activate():
	global.player_node.is_immune = true
	global.player_node.player.speed *= 5
	global.player_node.can_swap = false
	
	var weapon = global.player_node.get_weapon()
	weapon.damage_multiplier = damage_multiplier
	
	var dash_ghost = dash_ghost_node.instantiate()
	dash_ghost.setup(global.player_node)
	global.player_node.get_tree().current_scene.add_child(dash_ghost)
	
	await global.player_node.get_tree().create_timer(dash_duration).timeout
	
	dash_ghost.can_spawn = false
	
	global.player_node.is_immune = false
	global.player_node.player.speed = global.player_node.player.initial_speed
	
	await global.player_node.get_tree().create_timer(damage_duration).timeout
	
	weapon.reset()
	
	global.player_node.can_swap = true
