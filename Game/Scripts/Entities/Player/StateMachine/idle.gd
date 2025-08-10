extends States
class_name Player_Idle

func EnterState():
	pass

func _on_controls_has_input(dir):
	match dir:
		"Right":
			Set_State("Hop")
		"Left":
			Set_State("Hop")
		"Up":
			Set_State("Jump")
		
