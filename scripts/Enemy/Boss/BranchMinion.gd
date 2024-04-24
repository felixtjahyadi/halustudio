extends BaseEnemy


# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.play("idle")
	super()

func _physics_process(_delta):
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
