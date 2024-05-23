extends Control

signal play

var level1 = global.MAIN_LEVEL_PATH + "Level 1.tscn"
var character_select_ui = "res://scenes/UI/character_select.tscn"

func _on_play_click_end():
	play.emit()
	global.level = 1
	var _level = get_tree().change_scene_to_file(level1)

func _on_quit_click_end():
	get_tree().quit()


func _on_select_character_click_end():
	get_tree().change_scene_to_file(character_select_ui)


func _on_play():
	global.reset_characters()

func _on_debug_pressed():
	global.debug_count += 1
	if global.debug_count == 5:
		$PanelContainerDebug/MarginContainer/DEBUG.modulate = "ffffff"
		global.prev_characters = global.used_characters
		global.used_characters = global.debug_characters
	elif global.debug_count == 6:
		$PanelContainerDebug/MarginContainer/DEBUG.modulate = "ffffff00"
		global.used_characters = global.prev_characters
