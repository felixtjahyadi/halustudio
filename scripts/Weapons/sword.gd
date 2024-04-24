extends Node2D
class_name Sword

@onready var hitbox_component = $Sprite2D/HitboxComponent
@onready var animation_component = $AnimationPlayer
@onready var slice_hitbox = $Area2D/CollisionShape2D

func _ready():
	animation_component = $AnimationPlayer 
	animation_component.stop()
	slice_hitbox.disabled = true
	
func _process(delta):
	handle_sword()

func handle_sword():
	if Input.is_action_just_pressed("click"):
		slice_hitbox.disabled = false
		animation_component.play()

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "swing":
		slice_hitbox.disabled = true
