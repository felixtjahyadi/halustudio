extends Area2D

@onready var collision_area = $CollisionShape2D
@onready var timer = $Timer
@onready var damage_timer = $DamageTimer
@onready var sprite = $Sprite2D

@export var effect_duration: int = 1
@export var damage: int = 50

@onready var animation = $AnimatedSprite2D

var can_damage = true
var is_place = false:
	set(value):
		is_place = value
		
		if is_place:
			collision_area.disabled = false
			sprite.self_modulate = Color(1, 1, 1, 0.5)
			timer.start()
			damage_timer.start()
		else:
			queue_free()

func setup(effect_duration_p: int):
	effect_duration = effect_duration_p
	
func _ready():
	timer.wait_time = effect_duration

func _physics_process(delta):
	if not is_place:
		global_position = get_global_mouse_position()

func damage_enemy():
	var bodies = get_overlapping_bodies()
	
	for body in bodies:
		if not body.is_in_group('enemy') or not body.has_method('get_damage'): return
		body.get_damage(damage)

func _on_timer_timeout():
	queue_free()

func _on_damage_timer_timeout():
	animation.visible = true
	animation.play("default")
	damage_enemy()
