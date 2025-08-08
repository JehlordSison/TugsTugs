extends Node
class_name States

@onready var actor:= get_parent().get_parent()
signal Transitioned

func EnterState():
	pass

func UpdateState(_delta: float):
	pass

func UpdatePhysicsState(_delta: float):
	pass
	
func ExitState():
	pass
	
func InputState(_input: InputEvent):
	pass

func Set_State(state: String):
	Transitioned.emit(self, state)
