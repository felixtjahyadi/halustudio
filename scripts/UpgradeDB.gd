extends Node

const ICON_PATH = "res://assets/Icon/"
const MIN_PRICE = 50
const MAX_PRICE = 200
var UPGRADES = {
	"food":{
		"icon":"res://assets/Icon/food.png",
		"name":"FOOD",
		"description":"Heals player",
		"price":null,
		"type":"consumable",
	},
	"attack_up":{
		"icon":"res://assets/Icon/attack.png",
		"name":"ATTACK",
		"description":"Stronger Attack at cost of Attack Speed",
		"price":null,
		"type":"stats"
	},
	"atk_speed_up":{
		"icon":"res://assets/Icon/atk_speed.png",
		"name":"ATK SPD",
		"description":"Attack Faster at cost of Attack",
		"price":null,
		"type":"stats"
	},
	"shield_up":{
		"icon":"res://assets/Icon/shield.png",
		"name":"SHIELD",
		"description":"Reduce Damage at cost of Speed",
		"price":null,
		"type":"stats"
	},
	"speed_up":{
		"icon":"res://assets/Icon/speed.png",
		"name":"SPEED",
		"description":"Move Faster at cost of Armor",
		"price":null,
		"type":"stats"
	},
	"health_up":{
		"icon":"res://assets/Icon/health.png",
		"name":"HEALTH",
		"description":"You feel more Healthy",
		"price":null,
		"type":"stats"
	},
	"add_attack":{
		"icon":"res://assets/Icon/add_atk.png",
		"name":"ADD ATK",
		"description":"+1 to Projectile MAX 3, More does nothing",
		"price":null,
		"type":"stats"
	},
	"pick_range_up":{
		"icon":"res://assets/Icon/pick_range.png",
		"name":"PICK UP RANGE",
		"description":"Reach Further",
		"price":null,
		"type":"stats"
	}
}

func _ready():
	calculate_value()
			
func calculate_value():
	for i in UPGRADES:
		UPGRADES[i]["price"] = randi_range(MIN_PRICE, MAX_PRICE)
