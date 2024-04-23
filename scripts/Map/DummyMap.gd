extends Node2D

var doorId = 0

@onready var doorTileMap : TileMap = get_node("DoorTileMap")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# test enable disable door
	#if Input.is_action_just_pressed("click"):
		#var doorTiles = doorTileMap.get_used_cells_by_id(0)
		#print(doorTiles)
		#print(doorTileMap.get_used_cells(0))
		#print(doorTileMap.visibility_layer)
		#doorTileMap.set_layer_enabled(0, doorId == 1)
		#
		#doorId = (doorId + 1) % 2
	pass
