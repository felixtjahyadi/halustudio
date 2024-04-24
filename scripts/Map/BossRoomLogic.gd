extends RoomLogic

@export var boss = preload("res://scenes/Enemy/Boss/CorruptedTreeGuardian.tscn")

func _ready():
	super()
	boss = boss.instantiate()
	add_child(boss)

func startRoom():
	if _isRoomNotExplored:
		_isRoomNotExplored = false
		toggleDoor()
		# TODO : remove this after endRoom in super() was deleted

func _on_room_area_body_entered(body):
	if _isRoomNotExplored and body.is_in_group("player"):
		super(body)
		boss.start_animation()
