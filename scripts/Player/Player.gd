extends CharacterBody2D

class_name PlayerClass

signal all_dead(player: PlayerClass)
signal update_weapon_sprite(weapon : WeaponResource)
signal update_health_bar(value : float)
signal swap(value: bool)
signal dead
signal immune(value: bool)

var player : PlayerResource = preload("res://resources/Players/Archie.tres")

@onready var playerSprite : Sprite2D = $Sprite2D
@onready var animations : AnimationTree = $AnimationTree
@onready var health_bar : ProgressBar = $HealthBar
@onready var next_cooldown_timer: Timer = $NextCooldownTimer
@onready var prev_cooldown_timer: Timer = $PrevCooldownTimer
@onready var weapon = $Weapon
@onready var sprite = $Sprite2D

var last_direction = Vector2(0.1, 0.1)
var can_swap = true
var can_swap_next = true
var can_swap_prev = true
var swap_delay = 0.4
var is_dead = false

var is_immune = false:
	set(value):
		is_immune = value
		
		if is_immune:
			playerSprite.modulate = Color.YELLOW
		else:
			var tween = get_tree().create_tween()
			tween.tween_property(playerSprite, "modulate", Color.WHITE, 0.5)
		
		immune.emit(value)

func _on_immune(value: bool):
	var style_box_flat_fill = StyleBoxFlat.new()
	
	if is_immune:
		style_box_flat_fill.bg_color = Color.YELLOW
	else:
		var tween = get_tree().create_tween()
		tween.tween_property(style_box_flat_fill, "bg_color", Color.AQUAMARINE, 0.5)
	
	style_box_flat_fill.set_border_width_all(1)
	style_box_flat_fill.border_color = Color(.24,.10,.19)
	health_bar.add_theme_stylebox_override("fill", style_box_flat_fill)

func setup(p_player: PlayerResource):
	player = p_player

func _ready():
	_update()
	print(sprite.frame)
	
func _update():
	_update_sprite()
	update_weapon_sprite.emit(player.weapon)
	_health_bar_update()
	_update_timer()

func _update_sprite():
	playerSprite.texture = player.texture

func _update_timer():
	next_cooldown_timer.wait_time = global.get_next_character().cooldown
	prev_cooldown_timer.wait_time = global.get_prev_character().cooldown

func start_next_cooldown_timer():
	can_swap_next = false
	next_cooldown_timer.start()
	
func stop_next_cooldown_timer():
	next_cooldown_timer.stop()
	can_swap_next = true
	
func start_prev_cooldown_timer():
	can_swap_prev = false
	prev_cooldown_timer.start()
	
func stop_prev_cooldown_timer():
	prev_cooldown_timer.stop()
	can_swap_prev = true

# Movement
func _physics_process(delta):
	if is_dead: return
	move()

func move():	
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * player.speed if direction else Vector2.ZERO
	move_and_slide()

func _process(delta):
	_health_bar_update()
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
	#animations["parameters/Dead/blend_position"] = last_direction.x

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
	if is_immune: return
	
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
	else:
		print(area)

func _on_collect_area_entered(area):
	if area.is_in_group("loot"):
		if area.is_in_group("money"):
			var money_value = area.collect()
			global.money += money_value
			global.total_money_collected += money_value
		elif area.is_in_group("potion"):
			var heal_value = area.heal()
			player.health += heal_value
			if player.health >= player.initial_health:
				player.health == player.initial_health
		elif area.is_in_group("ammo"):
			var ammo_value = area.collect()
			player.weapon.ammo += ammo_value

# health bar
func get_health_percent():
	if player.health <= 0:
		return 0
	return float(player.health) / player.initial_health

func _health_bar_update():
	health_bar.value = get_health_percent()
	update_health_bar.emit()

# Swap player
func swap_listen():
	if global.character_alive_total() <= 1 or not can_swap: return
	
	if Input.is_action_just_pressed("swap_next") and global.next_character_is_alive() and can_swap_next:
		swap_player(global.character_alive_next())
		_update_timer()
		start_next_cooldown_timer()
	elif Input.is_action_just_pressed("swap_prev") and global.prev_character_is_alive() and can_swap_prev:
		swap_player(global.character_alive_prev())
		_update_timer()
		start_prev_cooldown_timer()

func swap_player(character: PlayerResource):
	reset_player()
	
	player = character
	_update()
	swap.emit(true)
	
	can_swap = false
	await get_tree().create_timer(swap_delay).timeout	
	can_swap = true
	
func reset_player():
	is_immune = false
	player.speed = player.initial_speed
	get_weapon().reset()

func _on_all_dead(player):
	get_tree().call_deferred("change_scene_to_file", "res://scenes/Map/Level/LoseScreen.tscn")

func get_weapon():
	return player.weapon

func set_weapon_state(skill_active: bool):
	if skill_active:
		disable_weapon()
	else:
		enable_weapon()

func disable_weapon():
	get_weapon().weapon_enabled = false

func enable_weapon():
	get_weapon().weapon_enabled = true
