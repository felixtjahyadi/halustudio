extends EnemyClass

class_name BranchMinion

func _physics_process(delta):
	super(delta)
	if chase and player:
		_attack_process()

func _attack_process():
	pass

func _process(delta):
	pass
