extends States
class_name Player_Death

@onready var animation = $"../../Animation"

func EnterState():
	animation.play("death")
