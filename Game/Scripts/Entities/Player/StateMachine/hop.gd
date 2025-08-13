extends States
class_name Player_Hop

@onready var animation = $"../../Animation"

func EnterState():
	animation.play("hop")

func UpdatePhysicsState(_delta: float):
	if(actor.velocity.y > 0):
		Set_State("Fall")
	
