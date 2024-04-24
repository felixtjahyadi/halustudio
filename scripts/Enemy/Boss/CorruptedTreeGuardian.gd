extends BaseEnemy

class_name CorruptedTreeGuardian

@export var maxMinionCount : int = 15
@export var minionList : Array = [
	preload("res://scenes/Enemy/Boss/BranchMinion.tscn"),
	preload("res://scenes/Enemy/normal_zombie.tscn")
]
@export var intervalSpawn : float = 1.0

#@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

@export var attack_cooldown : float = 5.0

var isAwake : bool = false

func _ready():
	#sprite.play("idle")
	sprite.play("sleep")
	super()

func _process(delta):
	if isAwake:
		if get_child_count() == 0:
			var count = _get_minion_count_randomizer()
			_spawn_minion(count)

func _physics_process(delta):
	pass

func _reset():
	await get_tree().create_timer(attack_cooldown).timeout
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
	await get_tree().create_timer(2.0).timeout
	sprite.play("start")
	await get_tree().create_timer(2.0).timeout
	sprite.play("idle")
	_reset()

func _on_hurt_box_hurt(damage, angle, knock_back_amount):
	print(get_child_count())
	if get_child_count() == 0:
		super(damage, angle, knock_back_amount)
