extends AbstractSkillButton

@onready var focus_border = $FocusBorder
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

func handle_click():
	skill_resource.activate()
	can_activate = false
	cooldown_timer.start()
	set_process(true)

func handle_focus():
	animation_player.play("active")
	is_focus = true
	skill_resource.focus()

func handle_unfocus():
	animation_player.stop()
	is_focus = false
	skill_resource.unfocus()
