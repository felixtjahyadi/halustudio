extends Control

var level = "res://scenes/Map/Level/Level 1.tscn"

func _on_play_click_end():
	var _level = get_tree().change_scene_to_file(level)

func _on_quit_click_end():
	get_tree().quit()
