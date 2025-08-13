extends States
class_name Player_Land

@onready var animation: AnimatedSprite2D = $"../../Animation"

func EnterState():
	animation.play("land")
	await animation.animation_finished
	Set_State("idle")
	
