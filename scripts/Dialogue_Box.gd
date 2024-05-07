extends Node

@export var dialogue_name: String

var character_names : Array = []
var dialogues : Array = []
var current_index = 0
var dialogue_index = 0
var dialogue_finished = true

func _ready():
	load_json_data()
	$Dialogue_Box/Body_NinePatchRect/Cont_NinePatchRect.hide()
	set_labels_and_sprite()

func load_json_data():
	var file = "res://assets/Json/data.json"
	var json_as_text = FileAccess.get_file_as_string(file)
	var json_as_dict = JSON.parse_string(json_as_text)
	
	if json_as_dict:
		for entry in json_as_dict[dialogue_name]:
			character_names.append(entry.name)
			dialogues.append(entry.dialogue)

func set_labels_and_sprite():
	if current_index < character_names.size():
		$Dialogue_Box/Body_NinePatchRect/Speaker_NinePatchRect/Speaker_Label.text = character_names[current_index]
		match character_names[current_index]:
			"Archie":
				$Dialogue_Box/Chara.texture = load("res://assets/Player/art/Archie.png")
			"Knight":
				$Dialogue_Box/Chara.texture = load("res://assets/Player/art/Knight.png")
			"Ninja":
				$Dialogue_Box/Chara.texture = load("res://assets/Player/art/Ninja.png")
		
		if dialogue_index < dialogues[current_index].size():
			$Dialogue_Box/Body_NinePatchRect/Body_MarginContainer/Body_Label.text = dialogues[current_index][dialogue_index]
			dialogue_index += 1
		else:
			dialogue_index = 0
			
			if current_index == character_names.size() - 1:
				queue_free()
			
			switch_character_and_dialogue()

	else:
		queue_free()

func _on_body_animation_player_animation_finished(anim_name):
	$Dialogue_Box/Body_NinePatchRect/Cont_NinePatchRect.show()
	dialogue_finished = true

func _input(event):
	if dialogue_finished:
		if Input.is_action_pressed("enter"):
			$Dialogue_Box/Body_NinePatchRect/Cont_NinePatchRect.hide()
			$Dialogue_Box/Body_NinePatchRect/Body_MarginContainer/Body_Label/Body_AnimationPlayer.stop()
			$Dialogue_Box/Body_NinePatchRect/Body_MarginContainer/Body_Label/Body_AnimationPlayer.play("Generate")
			dialogue_finished = false
			set_labels_and_sprite()

func switch_character_and_dialogue():
	current_index += 1
	if current_index >= character_names.size():
		current_index = 0
	set_labels_and_sprite()
