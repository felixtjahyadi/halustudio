extends ColorRect

@onready var display_name = $Name

@onready var icon = $ColorRect/Icon
@onready var item_price = $Price
@onready var description = $Description

var mouse_over = false
var item = null
var price = 0

@onready var player = get_tree().get_first_node_in_group("player")

signal selected_upgrade(upgrade, price)

func _ready():
	connect("selected_upgrade", Callable(player, "upgrade_char"))
	UpgradeDb.calculate_value()
	if item == null:
		item = "food"
	display_name.text = UpgradeDb.UPGRADES[item]["name"]
	price = UpgradeDb.UPGRADES[item]["price"]
	item_price.text = str(price)
	description.text = UpgradeDb.UPGRADES[item]["description"]
	icon.texture = load(UpgradeDb.UPGRADES[item]["icon"])

	
func _input(event):
	if event.is_action("click"):
		if mouse_over:
			emit_signal("selected_upgrade", item, price)

func _on_mouse_entered():
	mouse_over = true

func _on_mouse_exited():
	mouse_over = false
