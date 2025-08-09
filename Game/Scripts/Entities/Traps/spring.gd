extends Node2D

@export var force: int = 250

func _on_spring_body_entered(body):
	if(body is CharacterBody2D):
		#body.velocity.x *= 2
		body.global_position.x = lerp(body.global_position.x, global_position.x, 1)
		body.velocity.x *= 2
		body.velocity -= Vector2.DOWN.rotated(global_rotation) * force * 2
		$AudioStreamPlayer.play()
		
func _physics_process(delta):
	print(Vector2.DOWN.rotated(global_rotation))
