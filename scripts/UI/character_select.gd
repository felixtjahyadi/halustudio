extends Control

const menu_path = "res://scenes/Utils/title.tscn"
const character_select_info_path = preload("res://scenes/UI/character_select_info.tscn")

@onready var invalid_modal_layer = $CanvasLayer
@onready var characters_texture_rect = [
	$MarginContainer/VBoxContainer/HBoxContainer/Character1/TextureButton,
	$MarginContainer/VBoxContainer/HBoxContainer/Character2/TextureButton,
	$MarginContainer/VBoxContainer/HBoxContainer/Character3/TextureButton,
]

func _ready():
	for i in range(len(global.used_characters)):
		characters_texture_rect[i].texture_normal = global.used_characters[i].art

func _on_button_pressed():
	if global.character_combination_is_valid():
		get_tree().change_scene_to_file(menu_path)
	
	invalid_modal_layer.visible = true

func _on_button_close_pressed():
	invalid_modal_layer.visible = false

func _on_texture_button1_mouse_entered():
	var character_texture_rect = characters_texture_rect[0]
	var change_label = character_texture_rect.get_child(0)
	
	character_texture_rect.self_modulate = Color.BLACK
	change_label.visible = true

func _on_texture_button1_mouse_exited():
	var character_texture_rect = characters_texture_rect[0]
	var change_label = character_texture_rect.get_child(0)
	
	character_texture_rect.self_modulate = Color.WHITE
	change_label.visible = false

func _on_texture_button2_mouse_entered():
	var character_texture_rect = characters_texture_rect[1]
	var change_label = character_texture_rect.get_child(0)
	
	character_texture_rect.self_modulate = Color.BLACK
	change_label.visible = true

func _on_texture_button2_mouse_exited():
	var character_texture_rect = characters_texture_rect[1]
	var change_label = character_texture_rect.get_child(0)
	
	character_texture_rect.self_modulate = Color.WHITE
	change_label.visible = false
	
func _on_texture_button3_mouse_entered():
	var character_texture_rect = characters_texture_rect[2]
	var change_label = character_texture_rect.get_child(0)
	
	character_texture_rect.self_modulate = Color.BLACK
	change_label.visible = true

func _on_texture_button3_mouse_exited():
	var character_texture_rect = characters_texture_rect[2]
	var change_label = character_texture_rect.get_child(0)
	
	character_texture_rect.self_modulate = Color.WHITE
	change_label.visible = false


func _on_texture_button1_pressed():
	const scene = character_select_info_path
	global.character_change_index = 0
	get_tree().change_scene_to_packed(scene)


func _on_texture_button2_pressed():
	const scene = character_select_info_path
	global.character_change_index = 1
	get_tree().change_scene_to_packed(scene)


func _on_texture_button3_pressed():
	const scene = character_select_info_path
	global.character_change_index = 2
	get_tree().change_scene_to_packed(scene)


