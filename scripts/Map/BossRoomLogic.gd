extends RoomLogic

@export var boss = preload("res://scenes/Enemy/Boss/CorruptedTreeGuardian.tscn").instantiate()

func _ready():
	super()
	add_child(boss)

func startRoom():
	if _isRoomNotExplored:
		_isRoomNotExplored = false
		toggleDoor()
		# TODO : remove this after endRoom in super() was deleted

func _on_room_area_body_entered(body):
	if body.get_name() == "Player":
		super(body)
		boss.start_animation()
