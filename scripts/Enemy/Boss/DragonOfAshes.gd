extends EnemyClass

class_name DragonOfAshes

var attack_cooldown : float = 3

var isAwake : bool = false
var isFlying : bool = false

signal on_boss_dead()

func _ready():
	animationTree = $AnimationTree
	super()

func default_texture():
	pass

func default_animation():
	pass

func _physics_process(_delta):
	if isAwake:
		if hp <= 0:
			dead_process()
			animationTree.set("parameters/DeadTransition/transition_request", "dead")
		else:
			if isFlying:
				$CollisionEnemy.disabled = true
				animationTree.set("parameters/Transition/transition_request", "fly")
				
				var direction = global_position.direction_to(get_tree().get_first_node_in_group("player").global_position)
				velocity = direction * enemy.speed
				move_and_slide()
			else:
				$CollisionEnemy.disabled = false
				animationTree.set("parameters/Transition/transition_request", "idle")
			
	else:
		animationTree.set("parameters/Transition/transition_request", "sleep")

func emit_boss_dead():
	on_boss_dead.emit()

func _reset():
	await get_tree().create_timer(attack_cooldown).timeout
	attack_phase()
	_reset()

func attack_phase():
	reset_CommonAttackTransition()
	if isFlying:
		fly_attack()
	else:
		ground_attack()

func fly_attack():
	var attackIdx = randi_range(0, 2)
	if attackIdx == 0:
		attack_cooldown = 1
		transition()
	elif attackIdx == 1:
		attack_cooldown = 3
		animationTree.set("parameters/CommonAttackTransition/transition_request", "front")
	elif attackIdx == 2:
		attack_cooldown = 7
		animationTree.set("parameters/CommonAttackTransition/transition_request", "fly_dash")

func ground_attack():
	var attackIdx = randi_range(0, 4)
	if attackIdx == 0:
		attack_cooldown = 1
		transition()
	elif attackIdx == 1:
		attack_cooldown = 3
		animationTree.set("parameters/CommonAttackTransition/transition_request", "front")
	elif attackIdx == 2:
		attack_cooldown = 2
		animationTree.set("parameters/AttackTransition/transition_request", "attack_ground_slam")
		animationTree.set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	elif attackIdx == 3:
		attack_cooldown = 3
		animationTree.set("parameters/AttackTransition/transition_request", "attack_ground_big_slam")
		animationTree.set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	elif attackIdx == 4:
		attack_cooldown = 3
		animationTree.set("parameters/AttackTransition/transition_request", "attack_ground_slam")
		animationTree.set("parameters/AttackOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		transition()

func reset_CommonAttackTransition():
	if animationTree.get("parameters/CommonAttackTransition/current_state") != "none":
		animationTree.set("parameters/CommonAttackTransition/transition_request", "none")

func find_player():
	var player_direction = (get_tree().get_first_node_in_group("player").global_position - (global_position + Vector2(0, -110))).normalized()
	$EnemyBody/AttackNode/FrontHitBox.rotation = player_direction.angle()

func go_to_player():
	global_position = get_tree().get_first_node_in_group("player").global_position

func transition():
	if isFlying:
		animationTree.set("parameters/IdleFlyTransition/transition_request", "idle")
		animationTree.set("parameters/IdleFlyOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	else:
		animationTree.set("parameters/IdleFlyTransition/transition_request", "fly")
		animationTree.set("parameters/IdleFlyOneShot/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		await get_tree().create_timer(attack_cooldown).timeout
	isFlying = not isFlying

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


func zero_speed():
	enemy.speed = 0

func reset_speed():
	enemy.speed = enemy.initial_speed


func _on_hurt_box_hurt(damage, angle, knock_back_amount):
	_take_damage(damage)

func _on_melee_hurt_box_hurt(damage, angle, knock_back_amount):
	_take_damage(damage)
