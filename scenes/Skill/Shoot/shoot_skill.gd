extends Node2D

@onready var projectileSpawnPosition: Marker2D = $ProjectileSpawnPosition

@export var projectile_scene: PackedScene
@export var projectile_speed: int = 1000
@export var projectile_delay_second: float = 0.25
@export var projectile_range: int = 600
@export var projectile_spawn_offset: float = 15

var can_shoot = true

func _ready():
	var transform = Transform2D()
	transform.origin = Vector2(projectile_spawn_offset, 0)
	projectileSpawnPosition.transform = transform

func _process(delta):
	handle_shoot()

func handle_shoot():
	if Input.is_action_just_pressed("click") and can_shoot:
		spawn_bullet()
		cooldown_shoot_skill()

func spawn_bullet():
	look_at(get_global_mouse_position())
	var projectile_spawn_position = projectileSpawnPosition.get_global_position()
	
	var projectile_instance = projectile_scene.instantiate()
	projectile_instance.setup(projectile_spawn_position, projectile_range)
	projectile_instance.position = projectile_spawn_position
	projectile_instance.rotation_degrees = rotation_degrees
	projectile_instance.apply_impulse(Vector2(projectile_speed, 0).rotated(rotation))
	get_tree().get_root().add_child(projectile_instance)

func cooldown_shoot_skill():
	can_shoot = false
	await get_tree().create_timer(projectile_delay_second).timeout
	can_shoot = true
