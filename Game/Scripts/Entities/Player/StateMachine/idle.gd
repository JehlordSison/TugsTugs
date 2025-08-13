extends States
class_name Player_Idle

@onready var animation = $"../../Animation"

func EnterState():
	animation.play("idle")

func _on_controls_has_input(dir):
	match dir:
		"Right":
			Set_State("Hop")
		"Left":
			Set_State("Hop")
		"Up":
			Set_State("Jump")
		"Down":
			Set_State("Dance")
