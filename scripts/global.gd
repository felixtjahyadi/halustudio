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
	"Archie": load("res://resources/Players/Archie.tres"),
	"BadBullet": load("res://resources/Players/BadBullet.tres"),
	"Morin": load("res://resources/Players/Morin.tres"),
	"Reina": load("res://resources/Players/Reina.tres"),
	"Wade": load("res://resources/Players/Wade.tres"),
}

var owned_characters: Array[PlayerResource] = [
	all_characters["Archie"],
	all_characters["BadBullet"],
	all_characters["Morin"]
]

var used_characters: Array[PlayerResource] = [
	all_characters["Archie"],
	all_characters["BadBullet"],
	all_characters["Morin"]
]

var character_change_index: int = 0

func update_used_character(character: PlayerResource):
	used_characters[character_change_index] = character
	
func character_combination_is_valid():
	
	for character in owned_characters:
		if used_characters.count(character) > 1: return false
	
	return true
