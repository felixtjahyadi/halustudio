extends Node

@export var character_name : String = "Archie"
@export var dialogue : String = "Error Loading Dialogue..."

var dialogue_finished = false

func _ready():
	$Dialogue_Box/Body_NinePatchRect/Cont_NinePatchRect.hide()
	set_labels_and_sprite()

# Function to set node properties
func set_labels_and_sprite():
	# Set Speaker_Label text to character name
	$Dialogue_Box/Body_NinePatchRect/Speaker_NinePatchRect/Speaker_Label.text = character_name
	
	# Set Body_Label text to dialogue
	$Dialogue_Box/Body_NinePatchRect/Body_MarginContainer/Body_Label.text = dialogue
	
	# Change sprite depending on character name
	match character_name:
		"Archie":
			$Dialogue_Box/Chara.texture = load("res://assets/Player/art/Archie.png")
		"Knight":
			$Dialogue_Box/Chara.texture = load("res://assets/Player/art/Knight.png")
		"Ninja":
			$Dialogue_Box/Chara.texture = load("res://assets/Player/art/Ninja.png")

func _on_body_animation_player_animation_finished(anim_name):
	$Dialogue_Box/Body_NinePatchRect/Cont_NinePatchRect.show()
	# Set dialogue_finished flag to true
	dialogue_finished = true

func _input(event):
	if dialogue_finished:
		if Input.get_action_strength("enter"):
			queue_free()
