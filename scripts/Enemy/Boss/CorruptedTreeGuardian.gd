extends Boss

class_name CorruptedTreeGuardian

@export var maxMinionCount : int = 15
var minionList : Array = []

@onready var sprite : AnimatedSprite2D = $AnimatedSprite2D

func _ready():
	#sprite.play("idle")
	sprite.play("sleep")
	pass

func attack():
	if (minionList.size() <= maxMinionCount):
		var count = _get_minion_count_randomizer()
		_spawn_minion(count)

func _get_minion_count_randomizer():
	return randi_range(2, 5)

func _spawn_minion(count = 1):
	pass

func start_animation():
	await get_tree().create_timer(3.0).timeout
	sprite.play("awake")
	await get_tree().create_timer(2.0).timeout
	sprite.play("idle")
