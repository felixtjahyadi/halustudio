extends Node

# HUD Signal
signal swap

var debug_count = 0
var prev_characters : Array[PlayerResource] = []
var debug_characters : Array[PlayerResource] = [
	load("res://resources/Players/Archie_DEBUG.tres").setup(),
	load("res://resources/Players/Archie_DEBUG.tres").setup(),
	load("res://resources/Players/Archie_DEBUG.tres").setup()
]

var LEVEL_PATH : String = "res://scenes/Map/Level/"
var MAIN_LEVEL_PATH : String = LEVEL_PATH + "MainLevel/"
var VARIATIONS_LEVEL_PATH : String = LEVEL_PATH + "Variations/"

var level = 1

var variationsLevelCount = 2

var HITPOINTS: int = 5

var MAP_TEXTURE : Dictionary = {
	"FOREST": "Forest",
	"DUNGEON": "Dungeon",
}
var current_map_texture = MAP_TEXTURE.FOREST

# Enemy resource
var all_enemies: Dictionary = {
	"ForestGuard": load("res://resources/Enemies/ForestGuard.tres").setup(),
	"Slime": load("res://resources/Enemies/Slime.tres").setup(),
	"Specter": load("res://resources/Enemies/Specter.tres").setup(),
	"ZombieBoy": load("res://resources/Enemies/ZombieBoy.tres").setup(),
	"ZombieDoctor": load("res://resources/Enemies/ZombieDoctor.tres").setup(),
	"ZombieGirl": load("res://resources/Enemies/ZombieGirl.tres").setup(),
}

var current_enemies: Array[EnemyResource] = [
	all_enemies["ForestGuard"],
	all_enemies["Slime"],
	all_enemies["Specter"],
	all_enemies["ZombieBoy"],
	all_enemies["ZombieDoctor"],
	all_enemies["ZombieGirl"],
]

# Character select logic
var all_characters: Dictionary = {
	"Archie": load("res://resources/Players/Archie.tres").setup(),
	"BadBullet": load("res://resources/Players/BadBullet.tres").setup(),
	"Morin": load("res://resources/Players/Morin.tres").setup(),
	"Reina": load("res://resources/Players/Reina.tres").setup(),
	"Wade": load("res://resources/Players/Wade.tres").setup(),
}

var owned_characters: Array[PlayerResource] = [
	all_characters["Archie"],
	all_characters["BadBullet"],
	all_characters["Morin"],
	all_characters["Reina"],
	all_characters["Wade"],
]

# Character Selection
var used_characters: Array[PlayerResource] = [
	all_characters["Archie"],
	all_characters["BadBullet"],
	all_characters["Morin"]
]
var character_change_index: int = 0

func character_combination_is_valid():
	return owned_characters.all(func (character): return used_characters.count(character) <= 1 )

func update_used_character(character: PlayerResource):
	used_characters[character_change_index] = character

# Character in Game
var played_characters: Array[PlayerResource] = used_characters

# Reset character
func reset_characters():
	for character in all_characters.values():
		character.reset()
	
	played_characters = used_characters.duplicate()

## Get character
func get_current_character():
	return played_characters[0]

func get_next_character():
	return played_characters[1]
	
func get_prev_character():
	return played_characters[2]

## Swap character
func swap_character_position(idx1: int, idx2: int):
	var tmp_character = played_characters[idx1]
	played_characters[idx1] = played_characters[idx2]
	played_characters[idx2] = tmp_character
	
func swap_character_position_next():
	swap_character_position(0, 1)

func swap_character_position_prev():
	swap_character_position(0, 2)

# Character alive
func character_alive_total():
	return played_characters.reduce(func(accum, character): return accum + int(character.is_alive()), 0)

func next_character_is_alive():
	return get_next_character().is_alive()

func prev_character_is_alive():
	return get_prev_character().is_alive()

func character_alive_next():
	if get_next_character().is_alive():
		swap_character_position_next()
		swap.emit()
	elif get_prev_character().is_alive():
		swap_character_position_prev()
		swap.emit()

	return get_current_character()
	
func character_alive_prev():
	if get_prev_character().is_alive():
		swap_character_position_prev()
		swap.emit()
	elif get_next_character().is_alive():
		swap_character_position_next()
		swap.emit()

	return get_current_character()

# Spawn Character
var player_scene = preload("res://scenes/Player_new/Player.tscn")
var player_node: Node
	
func spawn_character(spawner: PlayerSpawner):
	player_node = player_scene.instantiate()
	player_node.setup(get_current_character())
	player_node.global_position = spawner.global_position
	spawner.get_parent().add_child.call_deferred(player_node)

# Money
var money = 0
var total_money_collected = 0

