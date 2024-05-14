extends RoomLogic

@export var boss = preload("res://scenes/Enemy_new/Boss/CorruptedTreeGuardian.tscn")

var player : PlayerClass

func _ready():
	super()
	boss = boss.instantiate()
	enemy_positions_container.add_child(boss)

func startRoom():
	super()
	boss.start_animation()

func endRoom():
	super()
	boss.end_animation()

func _on_room_area_body_entered(body):
	if body.is_in_group("player"):
		player = body
		startRoom()
		player_detector.queue_free()
