extends EnemyClass

class_name DragonOfAshes

var current_attack_cooldown = 3.0

var isAwake : bool = false
var isFlying : bool = false

signal on_boss_dead()

func _ready():
	animationTree = $AnimationTree
	
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
	
	hp = 10000

func _physics_process(_delta):
	if isAwake:
		if hp <= 0:
			dead_process()
			animationTree.set("parameters/DeadTransition/transition_request", "dead")
		else:
			if isFlying:
				animationTree.set("parameters/Transition/transition_request", "fly")
			else:
				animationTree.set("parameters/Transition/transition_request", "idle")
			
	else:
		animationTree.set("parameters/Transition/transition_request", "sleep")

func emit_boss_dead():
	on_boss_dead.emit()

func _reset():
	await get_tree().create_timer(current_attack_cooldown).timeout
	#current_attack_cooldown += attack_cooldown_inc
	attack_phase()
	_reset()

func attack_phase():
	var isAttack = randi_range(0,2)
	
	if isAttack > 0:
		attack()
	else:
		transition()

func attack():
	if isFlying:
		fly_attack()
	else:
		ground_attack()

func fly_attack():
	print("fly attack")

func ground_attack():
	print("ground attack")

func transition():
	if isFlying:
		animationTree.set("parameters/IdleFlyTransition/transition_request", "idle")
		animationTree.set("parameters/IdleFlyOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	else:
		animationTree.set("parameters/IdleFlyTransition/transition_request", "fly")
		animationTree.set("parameters/IdleFlyOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	isFlying = not isFlying

func _get_minion_count_randomizer():
	return randi_range(2, 5)

func start_animation():
	animationTree.set("parameters/Awake/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	animationTree.set("parameters/Transition/transition_request", "idle")
	isAwake = true
	_reset()

func _take_damage(damage):
	hp -= damage
	print('boss take damage, %d' %hp)
	damaged_animation()
	sound.play()

func _on_hurt_box_hurt(damage, angle, knock_back_amount):
	_take_damage(damage)

func _on_melee_hurt_box_hurt(damage, angle, knock_back_amount):
	_take_damage(damage)
