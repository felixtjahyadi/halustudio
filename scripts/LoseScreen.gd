extends Control

var level = "res://scenes/Utils/title.tscn"

func _on_menu_click_end():
	var _level = get_tree().change_scene_to_file(level)

func _process(delta):
	$AnimationPlayer.play("lose")
	pass
