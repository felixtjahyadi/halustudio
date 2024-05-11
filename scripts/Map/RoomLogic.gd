extends Node2D

class_name RoomLogic

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

const ENEMY_SCENES: Dictionary = {
	"ZOMBIE": preload("res://scenes/Enemy/normal_zombie.tscn"),
}

@export_enum("Forest", "Dungeon") var mapTexture : String = "Forest"

@export var skippable : bool = false

@export var lastRoom : bool = false
@export var levelPath : String = "Level 1"

@onready var roomTileMap : TileMap = get_node("RoomTileMap")
@onready var enemy_positions_container: Node2D = get_node("EnemyPosition")
@onready var player_detector: Area2D = get_node("PlayerDetector")

var portalScenePath : String = "res://scenes/Map/Objects/Portal.tscn"

var num_enemies: int

func _ready():
	_isRoomNotExplored = false if skippable else true
	_updateRoomTexture()
	toggleDoor()
	
	num_enemies = enemy_positions_container.get_child_count()
	
	if lastRoom:
		showPortal()

func _updateRoomTexture():
	roomTileMap.tile_set.get_source(0).texture = load(MAP_TEXTURES[mapTexture].wall)
	roomTileMap.tile_set.get_source(1).texture = load(MAP_TEXTURES[mapTexture].floor)
	roomTileMap.tile_set.get_source(2).texture = load(MAP_TEXTURES[mapTexture].door)
	
	remove_child(roomTileMap)
	add_child(roomTileMap)

func toggleDoor():
	# layer door = 1
	roomTileMap.set_layer_enabled(1, _isDoorClosed)
	_toggleIsDoorClosed()

func showPortal():
	var portal = load(portalScenePath).instantiate()
	portal.levelPath = levelPath
	add_child(portal)

func startRoom():
	if _isRoomNotExplored:
		_isRoomNotExplored = false
		toggleDoor()

func endRoom():
	toggleDoor()
	if lastRoom:
		showPortal()

func _spawn_enemies() -> void:
	for enemy_position in enemy_positions_container.get_children():
		var enemy: BaseEnemy
		enemy = ENEMY_SCENES.ZOMBIE.instantiate()
		enemy.position = enemy_position.position
		call_deferred("add_child", enemy)

func _on_enemy_killed():
	num_enemies -= 1
	if num_enemies == 0:
		endRoom()

func _on_player_detector_body_entered(body: CharacterBody2D):
	if body.is_in_group("player"):
		startRoom()
		player_detector.queue_free()
		if num_enemies > 0:
			_spawn_enemies()
