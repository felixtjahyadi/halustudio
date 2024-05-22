extends Node2D

@export var mainLevel : bool = false

@onready var animatedSprite : AnimatedSprite2D = get_node("AnimatedSprite2D")

# Called when the node enters the scene tree for the first time.
func _ready():
	animatedSprite.play("default")

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
	#pass

func _on_area_2d_body_entered(body: CharacterBody2D):
	if body.is_in_group("player"):
		global.level += 1
		if mainLevel:
			print(global.level)
			if floor((global.level-1) / 3) % 2 == 1:
				print("dungeon")
				global.current_map_texture = global.MAP_TEXTURE.DUNGEON
			else:
				print("forest")
				global.current_map_texture = global.MAP_TEXTURE.FOREST
			
			if global.level % 3 == 0:
				print("boss")
				get_tree().change_scene_to_file(global.MAIN_LEVEL_PATH + "Boss " + str(global.level) + ".tscn")
			else:
				print("normal")
				get_tree().change_scene_to_file(global.MAIN_LEVEL_PATH + "Level " + str(global.level) + ".tscn")
		else:
			get_tree().change_scene_to_file(global.VARIATIONS_LEVEL_PATH + str(randi_range(1, global.variationsLevelCount)) + ".tscn")
