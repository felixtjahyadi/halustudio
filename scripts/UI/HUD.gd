extends CanvasLayer

@onready var prev_character_texture_rect = $Avatar/MarginContainer/VBoxContainer/PrevCharacter
@onready var current_character_texture_rect = $Avatar/MarginContainer/VBoxContainer/HBoxContainer/CurrentCharacter
@onready var next_character_texture_rect = $Avatar/MarginContainer/VBoxContainer/HBoxContainer/NextCharacter

@onready var player_name = $CharacterInfo/MarginContainer/VBoxContainer/Name
@onready var health_bar = $CharacterInfo/MarginContainer/VBoxContainer/HealthBar

func _ready():
	_update()
	
	# Subscribe signal
	global.swap.connect(_update)
	global.player_node.update_health_bar.connect(update_health_bar)

func _update():
	update_avatar()
	update_player_name()
	update_health_bar()

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