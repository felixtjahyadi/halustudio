extends Node2D

var _isDoorClosed : bool = false
func _toggleIsDoorClosed():
	_isDoorClosed = !_isDoorClosed

var _isRoomNotExplored = true

const MAP_TEXTURES : Dictionary = {
	"Forest": {
		"wall": "res://assets/Map/wall_bush.png",
		"floor": "res://assets/Map/floor_grass.png",
		"door": "res://assets/Map/door.png"
	},
	"Dungeon": {
		"wall": "res://assets/Map/wall_stone.png",
		"floor": "res://assets/Map/floor_stone.png",
		"door": "res://assets/Map/door.png"
	}
}

@export_enum("Forest", "Dungeon") var mapTexture : String = "Forest"

@export var skippable : bool = false

@onready var roomTileMap : TileMap = get_node("RoomTileMap")

func _ready():
	_isRoomNotExplored = false if skippable else true
	_updateRoomTexture()
	toggleDoor()

func _updateRoomTexture():
	roomTileMap.tile_set.get_source(0).texture = load(MAP_TEXTURES[mapTexture].wall)
	roomTileMap.tile_set.get_source(1).texture = load(MAP_TEXTURES[mapTexture].floor)
	roomTileMap.tile_set.get_source(2).texture = load(MAP_TEXTURES[mapTexture].door)
	
	remove_child(roomTileMap)
	add_child(roomTileMap)

# func _process(delta):
# 	pass

func toggleDoor():
	# layer door = 2
	roomTileMap.set_layer_enabled(2, _isDoorClosed)
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
