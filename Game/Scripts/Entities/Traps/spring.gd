extends Node2D

@export var force: int = 250

func _on_spring_body_entered(body):
	if(body is CharacterBody2D):
		body.velocity.y = 0
		body.velocity -= Vector2.DOWN.rotated(global_rotation) * force
		
	
