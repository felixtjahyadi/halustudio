extends EnemyClass

class_name DragonOfAshes

@onready var animatedPlayer : AnimationPlayer = $EnemyBody/AnimationPlayer

@export var attack_cooldown_inc : float = 1.0

var current_attack_cooldown = 0.0

var isAwake : bool = false

var minionNum : int = 0

signal on_boss_dead()

func _ready():
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
	
	hp = 1000

func _physics_process(_delta):
	if isAwake:
		if hp <= 0:
			animationTree.set("parameters/Transition/transition_request", "dead")
			emit_signal("on_boss_dead")
			dead_process()
		else:
			animationTree.set("parameters/Transition/transition_request", "idle")
			
	else:
		animationTree.set("parameters/Transition/transition_request", "sleep")

func _reset():
	await get_tree().create_timer(current_attack_cooldown).timeout
	current_attack_cooldown += attack_cooldown_inc
	attack()
	_reset()

func attack():
	pass

func _get_minion_count_randomizer():
	return randi_range(2, 5)

func start_animation():
	animationTree.set("parameters/Awake/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	animationTree.set("parameters/Transition/transition_request", "idle")
	isAwake = true
	_reset()

func _take_damage(damage):
	if minionNum <= 0:
		hp -= damage
		print('boss take damage, %d' %hp)
		damaged_animation()
		sound.play()

func _on_hurt_box_hurt(damage, angle, knock_back_amount):
	_take_damage(damage)

func _on_melee_hurt_box_hurt(damage, angle, knock_back_amount):
	_take_damage(damage)