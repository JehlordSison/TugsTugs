extends States
class_name Player_Fall

func EnterState():
	pass

func UpdatePhysicsState(_delta: float):
	if(actor.is_on_floor()):
		Set_State("Idle")
	
