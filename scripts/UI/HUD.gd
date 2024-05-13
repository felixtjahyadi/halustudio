extends CanvasLayer

@onready var prev_character_texture_rect = $PanelContainer/MarginContainer/VBoxContainer/PrevCharacter
@onready var current_character_texture_rect = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/CurrentCharacter
@onready var next_character_texture_rect = $PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/NextCharacter

func _ready():
	update_avatar()
	
	# Subscribe global signal
	global.swap.connect(update_avatar)

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
