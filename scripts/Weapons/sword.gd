extends Node2D
class_name Sword

@onready var hitbox_component = $Sprite2D/HitboxComponent
@onready var animation_component = $AnimationPlayer
@onready var slice_hitbox = $Area2D/CollisionShape2D

func _ready():
	animation_component = $AnimationPlayer 
	animation_component.stop()
	
func _process(delta):
	handle_sword()

func handle_sword():
	if Input.is_action_just_pressed("click"):
		animation_component.play()
