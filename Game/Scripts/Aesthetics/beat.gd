extends AnimatedSprite2D

@onready var animation_player = $AnimationPlayer

func _ready():
	await get_tree().create_timer(3).timeout
	animation_player.play("hide")
	
