extends AbstractSkillButton

func handle_pressed():
	skill_resource.activate()
	can_activate = false
	cooldown_timer.start()
	set_process(true)
