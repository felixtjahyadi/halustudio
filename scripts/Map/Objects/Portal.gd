extends Node2D

@export var levelPath : String = "Level 1"

@onready var animatedSprite : AnimatedSprite2D = get_node("AnimatedSprite2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	animatedSprite.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func _on_area_2d_body_entered(body: CharacterBody2D):
	if body.is_in_group("player"):
		get_tree().change_scene_to_file(global.LEVEL_PATH + levelPath + ".tscn")
