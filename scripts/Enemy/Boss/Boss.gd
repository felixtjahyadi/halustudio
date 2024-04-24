extends Enemy

class_name Boss

var isAwake : bool = false

func _process(delta):
	pass

func start_animation():
	isAwake = true

func end_animation():
	pass
