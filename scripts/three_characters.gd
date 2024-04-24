extends Node2D

@export var character1: PackedScene
@export var character2: PackedScene
@export var character3: PackedScene
@export var character_change_delay_second: float = 0.5

var character1_node: Node
var character2_node: Node
var character3_node: Node
var total_character_alive = 3

var selected_character_node: Node
var can_change = true
var character_swap: Dictionary

func _ready():
	character1_node = character1.instantiate()
	character2_node = character2.instantiate()
	character3_node = character3.instantiate()
	
	# Set up character swap
	character_swap = {
		character1_node: [character2_node, character3_node],
		character2_node: [character3_node, character1_node],
		character3_node: [character1_node, character2_node]
	}
	
	# Add signal handler
	character1_node.connect('dead', character_dead_handler)
	character2_node.connect('dead', character_dead_handler)
	character3_node.connect('dead', character_dead_handler)
	
	# Default character
	selected_character_node = character1_node
	spawn_selected_character()
	
func _process(delta):
	if Input.is_action_just_pressed("swap") and can_change:
		swap_character()

func swap_character():
	remove_current_selected_charater()
	change_current_selected_charater()
	spawn_selected_character()
	cooldown_change_character()

func spawn_selected_character():
	add_child(selected_character_node)

func change_current_selected_charater():
	if len(character_swap[selected_character_node]) == 0: return
	
	var prev_character = selected_character_node
	var prev_character_position = selected_character_node.get_global_position()
	var prev_character_last_direction = selected_character_node.last_direction
	
	selected_character_node = character_swap[selected_character_node][0]
	
	selected_character_node.position = prev_character_position
	selected_character_node.last_direction = prev_character_last_direction
	
func remove_current_selected_charater():
	remove_child(selected_character_node)

func cooldown_change_character():
	can_change = false
	await get_tree().create_timer(character_change_delay_second).timeout
	can_change = true

func character_dead_handler(character: Node):
	for key in character_swap:
		if character in character_swap[key]:
			character_swap[key].erase(character)
	
	total_character_alive -= 1
	
	if total_character_alive == 0:
		# TODO: game over logic
		print('GAME OVER')
		pass

	swap_character()
