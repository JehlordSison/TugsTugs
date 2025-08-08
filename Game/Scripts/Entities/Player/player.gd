extends CharacterBody2D

@onready var character_physics: Node = $CharacterPhysics

func _physics_process(delta):
	character_physics.Gravity(delta)
	move_and_slide()
