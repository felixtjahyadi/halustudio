extends Enemy

class_name Boss

var isAwake : bool = false

func _process(delta):
	if isAwake:
		await get_tree().create_timer(attack_cooldown).timeout
		attack()

func start_animation():
	isAwake = true

func end_animation():
	pass
