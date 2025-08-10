extends CharacterBody2D

@onready var character_physics: Node = $CharacterPhysics
@onready var state_machine = $StateMachine
@onready var label = $Label

func _physics_process(delta):
	character_physics.Gravity(delta)
	move_and_slide()
	label.text = str(state_machine.current_state.name)
