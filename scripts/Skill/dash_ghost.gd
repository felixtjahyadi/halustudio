extends Node2D

var playerNode: PlayerClass
@onready var timer: Timer = $SpawnTimer

var can_spawn = true

func _ready():
	timer.start()
	
func _process(delta):
	if (get_child_count() == 1 and not can_spawn):
		queue_free()

func setup(player: PlayerClass):
	playerNode = player

func spawn_sprite_ghost():
	var sprite = Sprite2D.new()
	sprite.global_position = playerNode.global_position
	sprite.texture = playerNode.sprite.texture
	sprite.vframes = playerNode.sprite.vframes
	sprite.hframes = playerNode.sprite.hframes
	sprite.frame = playerNode.sprite.frame
	sprite.frame_coords = playerNode.sprite.frame_coords
	sprite.modulate = playerNode.sprite.modulate
	
	add_child(sprite)
	
	var tween = create_tween()
	tween.tween_property(sprite, "modulate", Color(1, 1, 1, 0), 2)
	tween.finished.connect(sprite.queue_free)

func _on_spawn_timer_timeout():
	if not can_spawn: return
	spawn_sprite_ghost()
