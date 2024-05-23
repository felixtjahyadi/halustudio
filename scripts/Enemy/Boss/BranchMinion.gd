extends EnemyClass

class_name BranchMinion

@export var attack_cooldown : float = 3.0

var attack_count = 0
var MAX_ATTACK = 3

signal on_minion_dead()

func _ready():
	super()
	_reset()

func _reset():
	await get_tree().create_timer(attack_cooldown).timeout
	_attack_process()
	_reset()

func default_animation():
	animationTree.set("parameters/Spawn/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	super()

func _physics_process(delta):
	if hp <= 0 or attack_count >= MAX_ATTACK:
		animationTree.set("parameters/DeadTransition/transition_request", "dead")
		dead_process()
		
	else:
		animationTree.set("parameters/Transition/transition_request", "idle")

func emit_on_minion_dead():
	on_minion_dead.emit()

func _attack_process():
	await get_tree().create_timer(attack_cooldown).timeout
	attack_count += 1
	animationTree.set("parameters/Attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func _process(delta):
	pass
