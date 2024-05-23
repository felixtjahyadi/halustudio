extends AbstractSkillButton

func handle_pressed():
	skill.activate()
	can_activate = false
	cooldown_timer.start()
	set_process(true)
