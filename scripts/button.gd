extends Button

signal click_end()

func _on_mouse_entered():
	pass

func _on_pressed():
	$Click.play()

func _on_click_finished():
	emit_signal("click_end")
