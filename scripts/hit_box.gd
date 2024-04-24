extends Area2D
class_name HitBox
@export var damage = 1

@onready var collision = $CollisionShape2D
@onready var disableTimer = $Timer

func tempdisable():
	collision.call_deferred("set", "disabled", true)
	disableTimer.start()

func _on_timer_timeout():
	collision.call_deferred("set", "disabled", false)
