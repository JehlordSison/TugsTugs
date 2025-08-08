extends Node

@onready var character_physics = $"../CharacterPhysics"
@onready var input_list_arr: Array = []

@export_category("Controls")
@export var hold_timer: float = .5

func _ready():
	get_game_speed()

func _physics_process(delta):
	key_hold(delta)
			
func _unhandled_input(event):
	key_press()
	if(Input.is_action_just_pressed("jump")):
		character_physics.Jump()
	
func key_press() -> void:
	for action in ActionList.ACTIONS:
		if(Input.is_action_just_pressed(action)):
			#input_list_arr.append(ActionList.ACTION_DIRECTIONS[action])
			input_list_arr.append(action_direction(ActionList.ACTION_DIRECTIONS[action]))
		
func key_hold(delta: float) -> void:
	for action in ActionList.ACTIONS:
		if(Input.is_action_pressed(action)):
			hold_timer += delta

func action_direction(dir: ActionList.Direction) -> String:
	return ActionList.Direction.keys()[dir]

func get_game_speed() -> void:
	var timer: Timer = get_tree().get_first_node_in_group("game_speed")
	timer.connect("timeout", _on_game_speed_timer_timeout)

func _on_game_speed_timer_timeout():
	if(input_list_arr.size() > 0):
		move_to(input_list_arr.get(0))
		input_list_arr.remove_at(0)
	
func move_to(action: String) -> void:
	match action:
		"Left":
			character_physics.Movement_Snap(Vector2.LEFT.x)
		"Right":
			character_physics.Movement_Snap(Vector2.RIGHT.x)
			
