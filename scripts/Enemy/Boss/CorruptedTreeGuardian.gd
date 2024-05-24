extends EnemyClass

class_name CorruptedTreeGuardian

@export var minionList : Array = [
	preload("res://scenes/Enemy_new/Boss/BranchMinion.tscn"),
]
@export var intervalSpawn : float = 1.0

var attack_cooldown : float = 3

var isAwake : bool = false

var minionNum : int = 0

signal on_boss_dead()

func _ready():
	animationTree = $AnimationTree
	sprite.modulate = Color.WHITE
	super()

func default_texture():
	pass

func default_animation():
	pass

func _physics_process(_delta):
	print(minionNum)
	if isAwake:
		if hp <= 0:
			dead_process()
			animationTree.set("parameters/DeadTransition/transition_request", "dead")
		else:
			animationTree.set("parameters/Transition/transition_request", "idle")
	else:
		animationTree.set("parameters/Transition/transition_request", "sleep")

func emit_boss_dead():
	on_boss_dead.emit()

func _reset():
	await get_tree().create_timer(attack_cooldown).timeout
	attack()
	_reset()

func attack():
	var attackIdx = randi_range(0,10)
	
	if minionNum == 0:
		await get_tree().create_timer(5).timeout
		_spawn_minion(5)
	
	if attackIdx == 0:
		attack_summon()
	elif attackIdx % 2 == 1:
		attack_area()
	elif attackIdx % 2 == 0:
		attack_front()

func attack_summon():
	var count = _get_minion_count_randomizer()
	attack_cooldown = count * 1.5
	_spawn_minion(count)

func attack_area():
	attack_cooldown = 2.2
	animationTree.set("parameters/AttackTransition/transition_request", "area")

func attack_front():
	attack_cooldown = 3
	animationTree.set("parameters/AttackTransition/transition_request", "front")

func find_player():
	var player_direction = (get_tree().get_first_node_in_group("player").global_position - global_position).normalized()
	$FrontHitBox.rotation = player_direction.angle()

func _get_minion_count_randomizer():
	return randi_range(5, 10)

func _spawn_minion(count = 1):
	for i in count:
		minionNum += 1
		_spawn()
		await get_tree().create_timer(intervalSpawn).timeout

func _spawn():
	var selectedMinion = minionList.pick_random()
	var minion = selectedMinion.instantiate()
	minion.connect("on_minion_dead", Callable(self, "_on_minion_dead"))
	add_child(minion)
	
	var spawn_pos = Vector2(0, 0)
	spawn_pos.x = randf_range(-64 * (10), 64 * (10))
	spawn_pos.y = randf_range(-64 * (10), 64 * (10))
	
	minion.position = spawn_pos

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
	else:
		sprite.modulate = Color.YELLOW
		await get_tree().create_timer(0.2).timeout
		sprite.modulate = Color.WHITE

func damaged_animation():
	sprite.modulate = Color.RED
	await get_tree().create_timer(0.2).timeout
	sprite.modulate = Color.WHITE

func _on_minion_dead():
	minionNum -= 1
	hp -= 10
	damaged_animation()

func _on_hurt_box_hurt(damage, angle, knock_back_amount):
	_take_damage(damage)

func _on_melee_hurt_box_hurt(damage, angle, knock_back_amount):
	_take_damage(damage)
