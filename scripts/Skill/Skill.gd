extends Node

class_name Skill

@export var cooldown: int
@export var texture: Texture2D
@export var skill_name: String
@export var description: String

func activate():
	'''
	Function to activate the skill
	'''
	print('activate')
	pass
