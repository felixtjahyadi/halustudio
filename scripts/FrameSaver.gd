extends Node

@onready var timer = $Timer

func _physics_process(_delta):
	if timer.is_stopped():
		if Engine.get_frames_per_second() < 55:
			disable_stuff(20)
		if Engine.get_frames_per_second() < 70:
			disable_stuff(10)
		if Engine.get_frames_per_second() > 85:
			disable_stuff(5)
			
func disable_stuff(_arg = 20):
	get_tree().call_group("enemy", "frame_save")
	timer.start()
