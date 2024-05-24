extends Control

signal play

@onready var panel_container = %PanelContainer
var level = "res://scenes/Map/Level/Level 1.tscn"
var character_select_ui = "res://scenes/UI/character_select.tscn"
var options_menu_scene = preload("res://scenes/ui/options_menu.tscn")


func _ready():
	$%OptionsButton.pressed.connect(on_options_pressed)
	
	
func _on_play_click_end():
	play.emit()
	var _level = get_tree().change_scene_to_file(level)


func _on_quit_click_end():
	get_tree().quit()


func on_options_pressed():
	ScreenTransition.transition()
	await ScreenTransition.transitioned_halfway
	var options_menu_instance = options_menu_scene.instantiate()
	add_child(options_menu_instance)
	options_menu_instance.back_pressed.connect(on_options_back_pressed.bind(options_menu_instance))
	

func on_options_back_pressed(options_menu: Node):
	options_menu.queue_free()


func _on_select_character_click_end():
	get_tree().change_scene_to_file(character_select_ui)


func _on_play():
	global.reset_characters()
