extends EnemyClass

class_name BranchMinion

@export var attack_cooldown : float = 3.0

func default_animation():
	animationTree.set("parameters/Spawn/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	super()

func _physics_process(delta):
	if hp <= 0:
		animationTree.set("parameters/Transition/transition_request", "dead")
		dead_process()
	elif chase and player:
		_attack_process()
	else:
		animationTree.set("parameters/Transition/transition_request", "idle")

func _attack_process():
	await get_tree().create_timer(attack_cooldown).timeout
	animationTree.set("parameters/Attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

func _process(delta):
	pass
