extends CanvasLayer

@onready var prev_character_texture_rect = $Avatar/MarginContainer/VBoxContainer/PrevCharacter
@onready var current_character_texture_rect = $Avatar/MarginContainer/VBoxContainer/HBoxContainer/CurrentCharacter
@onready var next_character_texture_rect = $Avatar/MarginContainer/VBoxContainer/HBoxContainer/NextCharacter

@onready var player_name = $CharacterInfo/MarginContainer/VBoxContainer/Name
@onready var health_bar = $CharacterInfo/MarginContainer/VBoxContainer/HealthBar

@onready var next_cooldown_bar = $Avatar/MarginContainer/VBoxContainer/HBoxContainer/NextCharacter/Cooldown
@onready var prev_cooldown_bar = $Avatar/MarginContainer/VBoxContainer/PrevCharacter/Cooldown

@onready var button_skills = $Utility/MarginContainer/VBoxContainer/ButtonSkills
@onready var skill_button_scene: PackedScene = load("res://scenes/Skill/skill_button.tscn")

func _ready():
	# Subscribe signal
	global.swap.connect(_update)
	global.player_node.update_health_bar.connect(update_health_bar)
	global.player_node.ready.connect(_update)
	set_process(true)
	
func _process(delta):
	update_cooldown()

func _update():
	update_avatar()
	update_player_name()
	update_health_bar()
	update_cooldown()
	update_skill()

func update_avatar():
	var prev_character = global.get_prev_character()
	var current_character = global.get_current_character()
	var next_character = global.get_next_character()
	
	# Update Texture Rect
	prev_character_texture_rect.texture = prev_character.avatar
	prev_character_texture_rect.modulate = Color.WHITE if prev_character.is_alive() else Color.DARK_RED
	
	current_character_texture_rect.texture = current_character.avatar
	current_character_texture_rect.modulate = Color.WHITE if current_character.is_alive() else Color.DARK_RED

	next_character_texture_rect.texture = next_character.avatar
	next_character_texture_rect.modulate = Color.WHITE if next_character.is_alive() else Color.DARK_RED

func update_player_name():
	player_name.text = global.get_current_character().name

func update_health_bar():
	health_bar.value = global.player_node.get_health_percent()

func update_cooldown():
	if not global.player_node.can_swap_next:
		next_cooldown_bar.max_value = global.player_node.next_cooldown_timer.wait_time
		next_cooldown_bar.value = global.player_node.next_cooldown_timer.time_left
	
	if not global.player_node.can_swap_prev:
		prev_cooldown_bar.max_value = global.player_node.prev_cooldown_timer.wait_time
		prev_cooldown_bar.value = global.player_node.prev_cooldown_timer.time_left

func update_skill():
	var current_character = global.get_current_character()
	var key = 1
	
	for button in button_skills.get_children():
		button.queue_free()
	
	for skill in current_character.skills:
		var skill_button = skill_button_scene.instantiate()
		
		if skill is FocusableSkillResource:
			skill_button.set_script(load("res://scripts/Skill/focusable_skill_button.gd"))
		else:
			skill_button.set_script(load("res://scripts/Skill/skill_button.gd"))
			
		skill_button.setup(skill, key)
		button_skills.add_child(skill_button)
		key += 1
