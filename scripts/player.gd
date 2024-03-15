extends CharacterBody2D

var mov_speed = 100.0
var hp = 80
var maxhp = 80
var money = 0
var total_money_collected = 0

var juicebox = preload("res://scenes/Player/juice_box.tscn")
var juice_ammo = 0
var juice_base_ammo = 1
var juice_attack_speed = 1.5
var juice_attack_level = 1

var enemy_close = []

var upgrade_options = []
var damage_up = 0
var armor = 0
var speed = 0
var cooldown = 0
var additional_atk = 0

var time = 0

@onready var sprite = $AnimatedSprite2D
@onready var juiceboxTimer = get_node("%JuiceBoxTimer")
@onready var juiceboxAttackTimer = get_node("%JuiceBoxAttackTimer")
@onready var coin_amount = get_node("%Coin")
@onready var store_panel = get_node("%Store")
@onready var store_options = get_node("%Options")
@onready var grab_area = get_node("%GrabAreaCol")
@onready var health_bar = get_node("%HealthBar")
@onready var lbl_timer = get_node("%LabelTimer")
@onready var death_panel = get_node("%Death")
@onready var result = get_node("%Result")
@onready var item_options = preload("res://scenes/Loot/item_options.tscn")
@onready var enemies = get_tree().get_nodes_in_group("enemy")
@onready var store_sound = $store_sound
@onready var win_sound = get_node("%win")
@onready var lost_sound = get_node("%lost")

signal player_death

func _ready():
	attack()
	coin_amount.text = str(money)
	_on_hurt_box_hurt(0,0,0)

func _physics_process(_delta):
	movement()
		
func movement():
	var x_mov = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_mov = Input.get_action_strength("down") - Input.get_action_strength("up")
	var mov = Vector2(x_mov,y_mov)
	if mov.x > 0:
		sprite.flip_h = false
	elif mov.x < 0:
		sprite.flip_h = true
		
	if mov != Vector2.ZERO:
		sprite.play("walk")
	else:
		sprite.play("idle")
	velocity = mov.normalized()*mov_speed
	move_and_slide()

func attack():
	if juice_attack_level > 0:
		juiceboxTimer.wait_time = juice_attack_speed * clamp(1-cooldown, 0.99, 3)
		if juiceboxTimer.is_stopped():
			juiceboxTimer.start()

func _on_hurt_box_hurt(damage, _angle, _knock_back_amount):
	hp -= clamp(damage-armor, 1, 999)
	health_bar.max_value = maxhp
	health_bar.value = hp
	if hp <= 0:
		death()

func _on_juice_box_timer_timeout():
	juice_ammo += clamp(juice_base_ammo + additional_atk,1,3)
	juiceboxAttackTimer.start()

func _on_juice_box_attack_timer_timeout():
	var target = get_closest_target()
	if juice_ammo > 0 and target != Vector2.ZERO:
		var juicebox_attack = juicebox.instantiate()
		juicebox_attack.position = position
		juicebox_attack.target = target
		juicebox_attack.level = juice_attack_level
		add_child(juicebox_attack)
		juice_ammo -= 1
		if juice_ammo > 0:
			juiceboxAttackTimer.start()
		else:
			juiceboxAttackTimer.stop()
		
func get_closest_target():
	var closest_distance = INF
	var closest_enemy = null
	
	for enemy in enemy_close:
		var distance = position.distance_to(enemy.global_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy.global_position
	
	if closest_enemy:
		return closest_enemy
	else:
		return Vector2.ZERO


func _on_detection_area_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)


func _on_detection_area_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)


func _on_grab_area_entered(area):
	if area.is_in_group("loot"):
		area.target = self

func _on_collect_area_entered(area):
	if area.is_in_group("loot"):
		var money_value = area.collect()
		money += money_value
		coin_amount.text = str(money)
		total_money_collected += money_value
		if total_money_collected >= 100:
			store_sound.play()
			store_open()
			total_money_collected -= 100
		
func store_open():
	var tween = store_panel.create_tween()
	tween.tween_property(store_panel, "position", Vector2(140,70), 0.2).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play()
	store_panel.visible = true
	var option = 0
	var option_max = 3
	while option < option_max:
		var choice = item_options.instantiate()
		choice.item = get_random_item()
		store_options.add_child(choice)
		option += 1
	get_tree().paused = true

func upgrade_char(upgrade, price):
	var option_children = store_options.get_children()
	if money >= price:
		match upgrade:
			"attack_up":
				damage_up += 0.3
				cooldown -= 0.1
			"atk_speed_up":
				cooldown += 0.05
				damage_up -= 0.05
			"shield_up":
				armor += 1
				mov_speed -= 20
			"speed_up":
				mov_speed += 20
				armor -= 1
			"health_up":
				maxhp += 20
				hp += 10
				_on_hurt_box_hurt(0,0,0)
			"pick_range_up":
				grab_area.shape.radius *= 1.05
			"add_attack":
				additional_atk += 1
			"food":
				hp += 20
				hp = clamp(hp, 0, maxhp)
				_on_hurt_box_hurt(0,0,0)
		attack()
		money -= price
		for i in option_children:
			i.queue_free()
		upgrade_options.clear()
		store_panel.visible = false
		store_panel.position = Vector2(1240,70)
		get_tree().paused = false
		
	else:
		print("Not enough money to purchase upgrade!")
		return
	coin_amount.text = str(money)
	
func get_random_item():
	var dbList =[]
	for i in UpgradeDb.UPGRADES:
		if i in upgrade_options:
			pass
		else:
			dbList.append(i)
	if dbList.size() > 0:
		var randomizeitem = dbList.pick_random()
		upgrade_options.append(randomizeitem)
		return randomizeitem
	
func change_time(argtime = 0):
	time = argtime
	var minute = int(time/60.0)
	var second = int(time) % 60
	if minute < 10:
		minute = str(0, minute)
	if second < 10:
		second = str(0, second)
	lbl_timer.text = str(minute, ":", second)

func death():
	death_panel.visible = true
	emit_signal("player_death")
	get_tree().paused = true
	var tween = death_panel.create_tween()
	tween.tween_property(death_panel, "position", Vector2(140,70), 3.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	if time >= 1200:
		result.text = "YOU WIN"
		win_sound.play()
	else:
		result.text = "YOU LOSE"
		lost_sound.play()

func _on_menu_click_end():
	get_tree().paused = false
	var _level = get_tree().change_scene_to_file("res://scenes/Utils/title.tscn")

func _on_close_button_click_end():
	var option_children = store_options.get_children()
	for i in option_children:
		i.queue_free()
	upgrade_options.clear()
	store_panel.visible = false
	store_panel.position = Vector2(1240,70)
	get_tree().paused = false
