extends TextureButton
class_name AbstractSkillButton

var skill: Skill
var key: int = 1
var can_activate = true

@onready var key_label = $Key
@onready var cooldown_timer = $Cooldown
@onready var cooldown_bar = $CooldownBar

signal skill_active(value: bool)

func setup(skill_p: Skill, key_p: int):
	skill = skill_p
	key = key_p
	texture_normal = skill_p.texture
	tooltip_text = skill.description

func _ready():
	update_shortcut_key()
	update_cooldown_timer()
	set_process(false)
	
func _process(delta):
	update_cooldown_bar()

func update_cooldown_bar():
	cooldown_bar.max_value = cooldown_timer.wait_time
	cooldown_bar.value = cooldown_timer.time_left
	
func update_shortcut_key():
	key_label.text = str(key)
	shortcut = Shortcut.new()
	var event_key = InputEventKey.new()
	event_key.keycode = KEY_0 + key
	event_key.unicode = KEY_0 + key
	shortcut.events.append(event_key)
	
func update_cooldown_timer():
	cooldown_timer.wait_time = skill.cooldown
	
func _on_pressed():
	if !can_activate: return
	
	handle_pressed()

func handle_pressed():
	'''
	Handle pressed for specific button type
	'''
	pass

func _on_cooldown_timeout():
	can_activate = true
	set_process(false)
