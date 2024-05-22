extends AbstractSkillButton

@onready var animation_player = $AnimationPlayer

var is_focus = false

func handle_pressed():
	var sibling_buttons = get_parent().get_children()
	
	# Make other button unfocus
	for button in sibling_buttons:
		if button == self: continue
		
		if button.has_method('handle_unfocus'):
			button.handle_unfocus()

	# Handle focus or unfocus
	if !is_focus:
		handle_focus()
	else:
		handle_unfocus()
		
func _process(delta):
	super._process(delta)
	
	if Input.is_action_just_pressed("click") and is_focus:
		handle_click()

func handle_click():
	animation_player.stop()
	is_focus = false
	
	skill.activate()
	can_activate = false
	cooldown_timer.start()
	set_process(true)

func handle_focus():
	animation_player.play("active")
	is_focus = true
	skill.focus()
	set_process(true)

func handle_unfocus():
	animation_player.stop()
	is_focus = false
	skill.unfocus()
