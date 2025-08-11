extends Node

@onready var character_physics = $"../CharacterPhysics"
@onready var input_list_arr: Array = []

@export_category("Controls")
#@export var hold_timer: float = .5
#var reset_hold_timer: float = hold_timer

@onready var game_interface = $"../GameInterface"

signal has_input(dir: String)
			
func _unhandled_input(_event):
	key_press()
	if(Input.is_action_just_pressed("restart")):
		get_tree().reload_current_scene()
	
func key_press() -> void:
	#if(get_beat_meter().accept_input):
	for action in ActionList.ACTIONS:
		if(Input.is_action_just_pressed(action)):
			move_to(action_direction(ActionList.ACTION_DIRECTIONS[action]))
			has_input.emit(action_direction(ActionList.ACTION_DIRECTIONS[action]))
			
func action_direction(dir: ActionList.Direction) -> String:
	return ActionList.Direction.keys()[dir]

func _on_game_speed_tick() -> void:
			#move_to(input_list_arr.get(0))
			#game_interface.play_direction_key(input_list_arr.get(0))
			#game_interface.delete_arrow_queue(0)
			#input_list_arr.remove_at(0)
	pass

func get_beat_meter() -> Node:
	var beat_meter: TextureProgressBar = get_tree().get_first_node_in_group("beat_duration")
	return beat_meter
	
func move_to(action: String) -> void:
	match action:
		"Left":
			character_physics.Movement_Snap(Vector2.LEFT.x)
		"Right":
			character_physics.Movement_Snap(Vector2.RIGHT.x)
		"Up":
			character_physics.Jump()
		"Down":
			pass
