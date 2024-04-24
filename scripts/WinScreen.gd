extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("walk")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$AnimatedSprite2D.position.x -= 2
	if $AnimatedSprite2D.position.x <= 850:
		$AnimationPlayer.play("tyfp")
	if $AnimatedSprite2D.position.x <= 10:
		return get_tree().change_scene_to_file("res://scenes/Utils/title.tscn")
