extends Area2D

@onready var collision_area = $CollisionShape2D
@onready var timer = $Timer
@onready var sprite = $Sprite2D

var effect_duration: int = 2
var is_place = false:
	set(value):
		is_place = value
		
		if is_place:
			collision_area.disabled = false
			timer.start()
			sprite.self_modulate = Color(1, 1, 1, 1)
		else:
			queue_free()

func setup(effect_duration_p: int):
	effect_duration = effect_duration_p
	
func _ready():
	timer.wait_time = effect_duration

func _physics_process(delta):
	if not is_place:
		global_position = get_global_mouse_position()

func _on_timer_timeout():
	queue_free()

func _on_body_entered(body):
	if body.is_in_group('enemy'):
		print('enemy entered')
		print('enemy damaged logic')

func _on_body_exited(body):
	if body.is_in_group('enemy'):
		print('enemy exited')
