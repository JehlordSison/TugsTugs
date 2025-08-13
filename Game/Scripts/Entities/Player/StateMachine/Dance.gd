extends States
class_name Player_Dance

@onready var animation = $"../../Animation"

func EnterState():
	animation.play("dance")

func InputState(_input: InputEvent):
	if(Input.is_action_just_released("move_down")):
		Set_State("Idle")
		
func _on_controls_has_input(dir):
	match dir:
		"Right":
			Set_State("Hop")
		"Left":
			Set_State("Hop")
		"Up":
			Set_State("Jump")
		
