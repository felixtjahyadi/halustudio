extends Node

var LEVEL_PATH : String = "res://scenes/Map/Level/"
var HITPOINTS: int = 5

var DIRECTION : Dictionary = {
	"NORTH": 0,
	"EAST" : 1,
	"SOUTH": 2,
	"WEST" : 3,
}

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

var used_characters: Array[PlayerResource] = [
	all_characters["Archie"],
	all_characters["BadBullet"],
	all_characters["Morin"]
]

var character_change_index: int = 0
var character_used_index: int = 0

func get_used_character():
	return used_characters[character_used_index]

func update_used_character(character: PlayerResource):
	used_characters[character_change_index] = character
	
func character_combination_is_valid():
	for character in owned_characters:
		if used_characters.count(character) > 1: return false
	
	return true

func character_alive_total():
	return used_characters.reduce(func(accum, character): return accum + int(character.is_alive()), 0)

func character_alive_next():
	for i in range(3):
		character_used_index = character_used_index+1 if character_used_index != len(used_characters)-1 else 0
		var character = get_used_character()
		
		if character.is_alive():
			return character
	
	push_error('All characters dead')
	
func character_alvie_prev():
	for i in range(3):
		character_used_index = character_used_index-1 if character_used_index != 0 else len(used_characters)-1
		var character = get_used_character()
		
		if character.is_alive():
			return character
			
	push_error('All characters dead')

func reset_characters():
	for character in all_characters.values():
		character.reset()
	
	character_used_index = 0

var player_scene = preload("res://scenes/Player_new/Player.tscn")
	
func spawn_character(spawner: PlayerSpawner):
	var player = player_scene.instantiate()
	player.setup(get_used_character())
	player.global_position = spawner.global_position
	spawner.get_parent().add_child.call_deferred(player)

# Money
var money = 0
var total_money_collected = 0

