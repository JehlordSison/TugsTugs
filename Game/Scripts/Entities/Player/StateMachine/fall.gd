extends States
class_name Player_Fall

@onready var animation = $"../../Animation"

func EnterState():
	animation.play("fall")
	
func UpdatePhysicsState(_delta: float):
	if(actor.is_on_floor()):
		Set_State("Idle")
	
