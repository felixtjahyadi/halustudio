extends Node2D
class_name Weapon

@export var on_floor: bool = false

@export var ranged_weapon: bool = false

@onready var player_detector: Area2D = get_node("PlayerDetector")

func _ready():
	if not on_floor:
		player_detector.set_collision_mask_value(1, false)
		player_detector.set_collision_mask_value(2, false)
		
func get_input():
	pass

func _on_player_detector_body_entered(body: CharacterBody2D):
	if body != null:
		player_detector.set_collision_mask_value(1, false)
		player_detector.set_collision_mask_value(2, false)
		body.pick_up_weapon(self)
		position = Vector2.ZERO
	else:
		player_detector.set_collision_mask_value(2, true)

func get_texture():
	return get_node("Node2D/Sprite2D").texture
