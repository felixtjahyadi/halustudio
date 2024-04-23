extends Node2D

var _isDoorClosed : bool = false
func _toggleIsDoorClosed():
	_isDoorClosed = !_isDoorClosed

var _isRoomNotExplored = true


@onready var doorTileMap : TileMap = get_node("DoorTileMap")

func _ready():
	toggleDoor()

# func _process(delta):
# 	pass

func toggleDoor():
	doorTileMap.set_layer_enabled(0, _isDoorClosed)
	_toggleIsDoorClosed()

func startRoom():
	if _isRoomNotExplored:
		_isRoomNotExplored = false
		toggleDoor()
		endRoom() # for test

func endRoom():
	await get_tree().create_timer(1.0).timeout
	toggleDoor()

func _on_room_area_body_entered(body):
	if body.get_name() == "Player":
		startRoom()
