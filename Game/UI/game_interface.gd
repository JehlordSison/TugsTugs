extends CanvasLayer

@onready var arrow_animation = $Panel/ArrowAnimation

func play_direction_key(dir: String) -> void:
	match dir: 
		"Right":
			arrow_animation.play("right")
		"Left":
			arrow_animation.play("left")
		"Up":
			arrow_animation.play("up")
		"":
			arrow_animation.play("none")
	
	await arrow_animation.animation_finished
	arrow_animation.play("none")
	print("Er")
