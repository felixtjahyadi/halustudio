extends Skill

class_name TestSkill

func _init():
	cooldown = 5 
	texture = load("res://assets/Skill/skill_image.png")
	description = "Test Skill"

func activate():
	'''
	Function to activate the skill
	'''
	print(get_tree())
	pass
