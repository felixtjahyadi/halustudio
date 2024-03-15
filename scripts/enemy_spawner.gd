extends Node2D

@export var spawns: Array[Spawn_info] = []

@onready var player = get_tree().get_first_node_in_group("player")

var time = 0
var enemy_cap = 500
var enemies_to_spawn = []

signal changetime(time)

func _ready():
	connect("changetime", Callable(player, "change_time"))

func _on_timer_timeout():
	time += 1.
	var enemy_spawns = spawns
	var children = get_children()
	for i in enemy_spawns:
		if time > i.time_start and time < i.time_end:
			if i.delay_counter < i.spawn_delay:
				i.delay_counter += 1
			else :
				i.delay_counter = 0
				var new_enemy = i.enemy
				var counter = 0
				while counter < i.enemy_num:
					if children.size() <= enemy_cap:
						var enemy_spawn = new_enemy.instantiate()
						enemy_spawn.scale *= i.scale_multiplier
						enemy_spawn.hp *= i.hp_multiplier
						enemy_spawn.max_coins *= i.money_multiplier
						enemy_spawn.global_position = get_random_position()
						add_child(enemy_spawn)
					else:
						enemies_to_spawn.append(new_enemy)
					counter += 1
	if children.size() <= enemy_cap and enemies_to_spawn.size() > 0:
		var num = clamp(enemies_to_spawn.size(), 1, 50) - 1
		var counter = 0
		while counter < num:
			var new_enemy = enemies_to_spawn[0].instantiate()
			new_enemy.global_position = get_random_position()
			add_child(new_enemy)
			enemies_to_spawn.remove_at(0)
			counter += 1
	emit_signal("changetime", time)
				
func get_random_position():
	var vpr = get_viewport_rect().size * randf_range(1.1, 1.4)
	var top_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y - vpr.y/2)
	var top_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y - vpr.y/2)
	var bottom_left = Vector2(player.global_position.x - vpr.x/2, player.global_position.y + vpr.y/2)
	var bottom_right = Vector2(player.global_position.x + vpr.x/2, player.global_position.y + vpr.y/2)
	var side = ["up", "down", "right", "left"].pick_random()
	var spawn1 = Vector2.ZERO
	var spawn2 = Vector2.ZERO
	
	match side:
		"up":
			spawn1 = top_left
			spawn2 = top_right
		"down":
			spawn1 = bottom_left
			spawn2 = bottom_right
		"right":
			spawn1 = top_right
			spawn2 = bottom_right
		"left":
			spawn1 = top_left
			spawn2 = bottom_left
	
	var x_spawn = randf_range(spawn1.x, spawn2.x)
	var y_spawn = randf_range(spawn1.y, spawn2.y)
	
	return Vector2(x_spawn, y_spawn)
