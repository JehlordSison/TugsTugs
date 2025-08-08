extends Node
class_name StateMachine

@export var initial_state: States
var current_state: States
var previous_state: States

var STATES: Dictionary = {}

func _ready():
	for child in get_children():
		if child is States:
			STATES[child.name.to_lower()] = child
			child.Transitioned.connect(on_state_transition)
			
	if initial_state:
		initial_state.EnterState()
		current_state = initial_state

func _process(delta):
	if current_state:
		current_state.UpdateState(delta)

func _physics_process(delta):
	if current_state:
		current_state.UpdatePhysicsState(delta)
	
func _unhandled_input(event):
	if current_state:
		current_state.InputState(event)	
	
func on_state_transition(previous, next):
	var new = STATES.get(next.to_lower())
	if previous != current_state:
		return
	if !new:
		return
	if current_state:
		current_state.ExitState()
	new.EnterState()
	previous_state = previous
	current_state = new
