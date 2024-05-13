extends CharacterBody2D

class_name PlayerClass

signal all_dead(player: PlayerClass)
signal update_weapon_sprite(weapon : WeaponResource)
signal update_health_bar(value : float)
signal swap(value: bool)
signal dead

var player : PlayerResource = preload("res://resources/Players/Archie.tres")

@onready var playerSprite : Sprite2D = $Sprite2D
@onready var animations : AnimationTree = $AnimationTree
@onready var health_bar : ProgressBar = $HealthBar

var last_direction = Vector2(0.1, 0.1)
var can_swap = true
var swap_delay = 0.4
var is_dead = false

func setup(p_player: PlayerResource):
	player = p_player

func _ready():
	_update()
	
func _update():
	_update_sprite()
	update_weapon_sprite.emit(player.weapon)
	_health_bar_update()

func _update_sprite():
	playerSprite.texture = player.texture

# Movement
func _physics_process(delta):
	if is_dead: return
	move()

func move():	
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * player.speed if direction else Vector2.ZERO
	move_and_slide()

func _process(delta):
	if is_dead: return
	set_animation()
	swap_listen()

func set_animation():
	set_walking()
	set_blend_position()

func set_walking():
	var direction = Input.get_vector("left", "right", "up", "down")
	var is_walking = direction != Vector2.ZERO
	animations["parameters/conditions/is_walking"] = is_walking
	animations["parameters/conditions/idle"] = not is_walking
	
	if is_walking and direction.x != 0: last_direction = direction

func set_blend_position():
	animations["parameters/Idle/blend_position"] = last_direction.x
	animations["parameters/Walk/blend_position"] = last_direction.x
	animations["parameters/Dead/blend_position"] = last_direction.x

func set_swap_animation(value = false):
	animations["parameters/conditions/is_swap"] = value

func set_dead_animation(value = false):
	animations["parameters/conditions/is_dead"] = value
	
func _on_dead():
	set_dead_animation(true)
	is_dead = true

func swap_next_when_dead():
	set_dead_animation(false)
	await get_tree().create_timer(swap_delay).timeout
	swap_player(global.character_alive_next())
	is_dead = false

# hurt box handler
func _on_hurt_box_hurt(damage, angle, knock_back_amount):
	player.take_hit(damage)
	_health_bar_update()
	damaged_animation()
	if player.health <= 0:
		if global.character_alive_total() == 0: 
			all_dead.emit(self)
		else:
			dead.emit()

func damaged_animation():
	modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	modulate = Color.WHITE

# loot grabber
func _on_grab_area_entered(area):
	if area.is_in_group("loot"):
		area.target = self

func _on_collect_area_entered(area):
	if area.is_in_group("loot"):
		var money_value = area.collect()
		global.money += money_value
		global.total_money_collected += money_value

# health bar
func get_health_percent():
	if player.health <= 0:
		return 0
	return float(player.health) / player.initial_health

func _health_bar_update():
	health_bar.value = get_health_percent()

# Swap player
func swap_listen():
	if global.character_alive_total() <= 1 or not can_swap: return
	
	if Input.is_action_just_pressed("swap_next") and global.next_character_is_alive():
		swap_player(global.character_alive_next())
	elif Input.is_action_just_pressed("swap_prev") and global.prev_character_is_alive():
		swap_player(global.character_alive_prev())

func swap_player(character: PlayerResource):
	player = character
	_update()
	swap.emit(true)
	
	can_swap = false
	await get_tree().create_timer(swap_delay).timeout	
	can_swap = true

func _on_all_dead(player):
	get_tree().call_deferred("change_scene_to_file", "res://scenes/Map/Level/LoseScreen.tscn")
