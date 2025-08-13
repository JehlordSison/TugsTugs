extends States
class_name Player_Jump

@onready var animation = $"../../Animation"

func EnterState():
	animation.play("jump")

func UpdatePhysicsState(_delta: float):
	if(actor.velocity.y > 0):
		Set_State("Fall")
