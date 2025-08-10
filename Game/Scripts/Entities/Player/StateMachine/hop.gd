extends States
class_name Player_Hop

func EnterState():
	pass

func UpdatePhysicsState(_delta: float):
	if(actor.velocity.y > 0):
		Set_State("Fall")
	
