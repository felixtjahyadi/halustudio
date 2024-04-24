extends AnimatedSprite2D

func _ready():
	visible = false

func _on_visibility_changed():
	if visible == true:
		play("default")

func _on_frame_changed():
	if frame == 7:
		stop()
		frame = 0
		visible = false
