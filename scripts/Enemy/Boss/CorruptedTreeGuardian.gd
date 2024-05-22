extends EnemyClass

class_name CorruptedTreeGuardian

@export var maxMinionCount : int = 15
@export var minionList : Array = [
	preload("res://scenes/Enemy_new/Boss/BranchMinion.tscn"),
]
@export var intervalSpawn : float = 1.0

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
		if minionNum > 0:
			sprite.modulate = Color.BLACK
		else:
			sprite.modulate = Color.WHITE
			
		if hp <= 0:
			animationTree.set("parameters/Transition/transition_request", "dead")
			dead_process()
		else:
			animationTree.set("parameters/Transition/transition_request", "idle")
			
	else:
		animationTree.set("parameters/Transition/transition_request", "sleep")

func emit_boss_dead():
	on_boss_dead.emit()

func _reset():
	await get_tree().create_timer(current_attack_cooldown).timeout
	current_attack_cooldown += attack_cooldown_inc
	attack()
	_reset()

func attack():
	if (get_child_count() <= maxMinionCount):
		var count = _get_minion_count_randomizer()
		_spawn_minion(count)

func _get_minion_count_randomizer():
	return randi_range(2, 5)

func _spawn_minion(count = 1):
	for i in count:
		_spawn()
		await get_tree().create_timer(intervalSpawn).timeout

func _spawn():
	var selectedMinion = minionList.pick_random()
	var minion = selectedMinion.instantiate()
	add_child(minion)
	
	var spawn_pos = Vector2(0, 0)
	spawn_pos.x = randf_range(-32 * (9-1), 32 * (9-1))
	spawn_pos.y = randf_range(-32 * (9-1), 32 * (9-1))
	
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

func _on_enemy_killed():
	minionNum -= 1

func _on_hurt_box_hurt(damage, angle, knock_back_amount):
	_take_damage(damage)

func _on_melee_hurt_box_hurt(damage, angle, knock_back_amount):
	_take_damage(damage)
