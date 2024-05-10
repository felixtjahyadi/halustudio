extends Marker2D

class_name PlayerSpawner

func _on_tree_entered():
	global.spawn_character(self)
