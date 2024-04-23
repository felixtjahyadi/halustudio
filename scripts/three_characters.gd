extends Node2D

@export var character1: PackedScene
@export var character2: PackedScene
@export var character3: PackedScene
@export var character_change_delay_second: float = 0.5

var character1_node: Node
var character2_node: Node
var character3_node: Node

var selected_character_node: Node
var can_change = true

func _ready():
	character1_node = character1.instantiate()
	character2_node = character2.instantiate()
	character3_node = character3.instantiate()
	
	# Default character
	selected_character_node = character1_node
	spawn_selected_character()
	
func _process(delta):
	swap_character()

func swap_character():
	if !Input.is_action_just_pressed("swap") or !can_change: return
	
	remove_current_selected_charater()
	change_current_selected_charater()
	spawn_selected_character()
	cooldown_change_character()

func spawn_selected_character():
	selected_character_node.position = get_global_position()
	add_child(selected_character_node)
	print(get_children())

func change_current_selected_charater():
	match selected_character_node:
		character1_node:
			selected_character_node = character2_node
		character2_node:
			selected_character_node = character3_node
		character3_node:
			selected_character_node = character1_node
	
func remove_current_selected_charater():
	remove_child(selected_character_node)

func cooldown_change_character():
	can_change = false
	await get_tree().create_timer(character_change_delay_second).timeout
	can_change = true
