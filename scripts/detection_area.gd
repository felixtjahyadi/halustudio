extends Area2D

signal entered(body)
signal exited(body)

func _ready():
	area_entered.connect(on_area_entered)

func on_area_entered(other_area: Area2D):
	if not other_area is Player:
		return
	
	entered.emit()



