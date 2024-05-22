extends CharacterBody2D

class_name EnemyClass

@export var enemy : EnemyResource = preload("res://resources/Enemies/Slime.tres")

#@export var mov_speed = 100.0
var hp

var knock_back = Vector2.ZERO
var screen_size
var death = preload("res://scenes/Enemy/death.tscn")
var coins = preload("res://scenes/Loot/Coin.tscn")
var potions = preload("res://scenes/Loot/Potion.tscn")
var chase = false
var current_player = null

@onready var player = get_tree().get_first_node_in_group("player")
@onready var loot_base = get_tree().get_first_node_in_group("loot")
@onready var collision = $CollisionEnemy
@onready var hitbox = $EnemyBody/HitBox
@onready var sprite = $EnemyBody/Sprite2D
@onready var attackSprite = $EnemyBody/AttackSprite2D
#@onready var animationPlayer = $EnemyBody/AnimationPlayer
@onready var animationTree = $EnemyBody/AnimationTree
@onready var hideTimer = $EnemyBody/HideTimer
@onready var hurtbox = $EnemyBody/HurtBox
@onready var meleehurtbox = $EnemyBody/HurtBox2
@onready var detectionArea = $EnemyBody/DetectionArea
@onready var detectionAreaShape = $EnemyBody/DetectionArea/CollisionShape2D
@onready var sound = $EnemyBody/hurt_sound

signal remove_from_array(object)

func _ready():
	enemy.setup()
	
	var __ = connect("tree_exited", Callable(get_parent(), "_on_enemy_killed"))
	hitbox.damage = enemy.initial_damage
	screen_size = get_viewport_rect().size
	hurtbox.connect("hurt", Callable(self, "_on_hurt_box_hurt"))
	meleehurtbox.connect("hurt", Callable(self, "_on_melee_hurt_box_hurt"))
	hideTimer.connect("timeout", Callable(self, "_on_hide_timer_timeout"))
	detectionArea.body_entered.connect(_on_detection_area_body_entered)
	detectionArea.body_exited.connect(_on_detection_area_body_exited)
	#detectionAreaShape.shape = CircleShape2D.new()
	detectionAreaShape.shape.radius = enemy.detectionRadius
	
	hp = enemy.initial_health
	
	sprite.texture = enemy.texture
	attackSprite.texture = enemy.attackTexture
	default_animation()

func default_animation():
	animationTree.set("parameters/Transition/transition_request", "idle")

func _physics_process(_delta):
	if hp <= 0:
		animationTree.set("parameters/Transition/transition_request", "dead")
		dead_process()
	elif chase and player:
		animationTree.set("parameters/Transition/transition_request", "walk")
		
		knock_back = knock_back.move_toward(Vector2.ZERO, enemy.knock_back_recovery)
		var direction = global_position.direction_to(player.global_position)
		if direction.x > 0.1:
			sprite.flip_h = true
		elif direction.x < -0.1:
			sprite.flip_h = false
		
		velocity = direction * enemy.initial_speed
		velocity += knock_back
		move_and_slide()
		
	else:
		animationTree.set("parameters/Transition/transition_request", "idle")

func dead_process():
	var enemy_death = death.instantiate()
	enemy_death.global_position = global_position
	get_parent().call_deferred("add_child", enemy_death)
	emit_signal("remove_from_array", self)
	var num_coins = randi() % int(enemy.max_coins) + 1 if int(enemy.max_coins) > 0 else 0
	#for i in range(num_coins):
		#var new_coin = coins.instantiate()
		#var new_potion = potions.instantiate()
		#new_coin.global_position = global_position + Vector2(randf_range(-60, 60), randf_range(-60, 60))
		#new_coin.money = enemy.money
		#new_potion.global_position = global_position + Vector2(randf_range(-60, 60), randf_range(-60, 60))
		#new_potion.money = enemy.money
		#loot_base.call_deferred("add_child", new_coin)
		#loot_base.call_deferred("add_child", new_potion)
	#queue_free() # already implemented in AnimationPlayer

func damaged_animation():
	modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	modulate = Color.WHITE

func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		player = body
		chase = true
	
func _on_detection_area_body_exited(body):
	if body.is_in_group("player") and body == player:
		player = null
		chase = false
	
func _on_hurt_box_hurt(damage, angle, knock_back_amount):
	print('hurtbox: ', hp)
	get_damage(damage, angle, knock_back_amount)

func _on_melee_hurt_box_hurt(damage, angle, knock_back_amount):
	print('on_melee: ', hp)
	get_damage(damage, angle, knock_back_amount)

func get_damage(damage, angle = 0, knock_back_amount = Vector2.ZERO):
	print('damage ', damage)
	hp -= damage
	damaged_animation()
	knock_back = angle * knock_back_amount
	sound.play()

func _on_hide_timer_timeout():
	var loc_dif = global_position - player.global_position
	if abs(loc_dif.x) > (screen_size.x/2) * 1.4 || abs(loc_dif.y) > (screen_size.y/2) * 1.4:
		visible = false
	else:
		visible = true

func frame_save(amount = 20):
	var rand_disable = randi() % 100
	if rand_disable < amount:
		collision.call_deferred("set", "disabled", true)
		#sprite.stop()
	
func increase_hp():
	hp *= 2
	
