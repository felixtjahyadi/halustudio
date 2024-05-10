extends Control
@onready var header =  $MarginContainer/VBoxContainer/Label
@onready var character_texture = $MarginContainer/VBoxContainer/VBoxContainer2/HBoxContainer/Character/TextureRect
@onready var character_name_label = $"MarginContainer/VBoxContainer/VBoxContainer2/VBoxContainer/CharacterInfo/Charater Name"
@onready var character_desc_label = $MarginContainer/VBoxContainer/VBoxContainer2/VBoxContainer/CharacterInfo/Description
@onready var character_health_label = $MarginContainer/VBoxContainer/VBoxContainer2/VBoxContainer/CharacterStat/Status/Health/Label
@onready var character_speed_label = $MarginContainer/VBoxContainer/VBoxContainer2/VBoxContainer/CharacterStat/Status/Speed/Label
@onready var character_armor_label = $MarginContainer/VBoxContainer/VBoxContainer2/VBoxContainer/CharacterStat/Status/Armor/Label

var selected_character_index = 0;

func _ready():
	header.text = "Select Your 3Gun Character %s" % [global.character_change_index + 1]
	update_character_information()
	
func _on_prev_pressed():
	selected_character_index = len(global.owned_characters) - 1 if selected_character_index == 0 else selected_character_index - 1
	update_character_information()

func _on_next_pressed():
	selected_character_index = 0 if selected_character_index == len(global.owned_characters) - 1 else selected_character_index + 1
	update_character_information()

func update_character_information():
	var current_character = global.owned_characters[selected_character_index]
	character_texture.texture = current_character.art
	character_name_label.text = current_character.name
	character_health_label.text = str(current_character.health)
	character_speed_label.text = str(current_character.speed)
	character_armor_label.text = str(current_character.armor)


func _on_select_pressed():
	global.update_used_character(global.owned_characters[selected_character_index])
	get_tree().change_scene_to_file("res://scenes/UI/character_select.tscn")


func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/UI/character_select.tscn")
