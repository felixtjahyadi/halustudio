extends Node2D

@export var levelPath : String = "Level 1"

# Called when the node enters the scene tree for the first time.
#func _ready():
	#pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func _on_area_2d_body_entered(body):
	if body.get_name() == "Player":
		get_tree().change_scene_to_file(global.LEVEL_PATH + levelPath + ".tscn")
