extends Boss

class_name CorruptedTreeGuardian

@export var maxMinionCount : int = 15
@export var minionList : Array = [preload("res://scenes/Enemy/Boss/BranchMinion.tscn")]
@export var intervalSpawn : float = 1.0

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

var onFieldMinions = []

func _ready():
	#sprite.play("idle")
	sprite.play("sleep")
	super()

func _process(delta):
	if isAwake and onFieldMinions.size() == 0:
		var count = _get_minion_count_randomizer()
		_spawn_minion(count)
	super(delta)

func _reset():
	await get_tree().create_timer(attack_cooldown).timeout
	attack()
	_reset()

func attack():
	if (onFieldMinions.size() <= maxMinionCount):
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
	get_parent().add_child(minion)
	
	var spawn_pos = Vector2(0, 0)
	spawn_pos.x = randf_range(-32 * 9, 32 * 9)
	spawn_pos.y = randf_range(-32 * 9, 32 * 9)
	
	minion.position = spawn_pos
	
	onFieldMinions.append(minion)

func start_animation():
	await get_tree().create_timer(3.0).timeout
	sprite.play("awake")
	await get_tree().create_timer(2.0).timeout
	sprite.play("idle")
	_reset()
	super()
