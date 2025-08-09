extends Node

@onready var character_physics = $"../CharacterPhysics"
@onready var input_list_arr: Array = []

@export_category("Controls")
@export var hold_timer: float = .5
var reset_hold_timer: float = hold_timer

@onready var game_interface = $"../GameInterface"

func _ready():
	get_game_speed()
#
func _process(delta):
	key_hold(delta)
			
func _unhandled_input(event):
	key_press()
	if(Input.is_action_just_pressed("jump")):
		character_physics.Jump()
	if(Input.is_action_just_pressed("restart")):
		get_tree().reload_current_scene()
	
func key_press() -> void:
	for action in ActionList.ACTIONS:
		if(Input.is_action_just_pressed(action)):
			max_input_reached(action)
			
func key_hold(delta: float) -> void:
	var pressing: bool = false
	for action in ActionList.ACTIONS:
		if(Input.is_action_pressed(action)):
			pressing = true
			hold_timer -= delta
			
			if(hold_timer <= 0):
				hold_timer = reset_hold_timer
				max_input_reached(action)
			break
			
	if(pressing == false):
		hold_timer = reset_hold_timer

func max_input_reached(action: String) -> void:
	if(input_list_arr.size() <= 4):
		input_list_arr.append(action_direction(ActionList.ACTION_DIRECTIONS[action]))
		game_interface.add_arrow_queue(action_direction(ActionList.ACTION_DIRECTIONS[action]))
		print()

func action_direction(dir: ActionList.Direction) -> String:
	return ActionList.Direction.keys()[dir]

func get_game_speed() -> void:
	var timer: Timer = get_tree().get_first_node_in_group("game_speed")
	timer.connect("timeout", _on_game_speed_timer_timeout)

func _on_game_speed_timer_timeout():
	if(input_list_arr.size() > 0):
		if(character_physics.actor.is_on_floor()):
			move_to(input_list_arr.get(0))
			game_interface.play_direction_key(input_list_arr.get(0))
			game_interface.delete_arrow_queue(0)
			input_list_arr.remove_at(0)

func move_to(action: String) -> void:
	match action:
		"Left":
			character_physics.Movement_Snap(Vector2.LEFT.x)
		"Right":
			character_physics.Movement_Snap(Vector2.RIGHT.x)
		"Up":
			character_physics.Jump()
			
