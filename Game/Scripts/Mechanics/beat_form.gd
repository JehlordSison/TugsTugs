extends Area2D
@onready var collision_shape_2d = $CollisionShape2D
@onready var marker = $Marker

@export var hop_count: int
@export var holdable: bool
@export var hold_time: float
@export var completed: bool = false ## Beats Finishes all

signal next_batch
signal gameover ## Connect this to gameMachine

func _ready():
	marker.play("In")

func _on_body_entered(_body):
	hop_count -= 1
	marker.play("In")
	add_step_effect()
	
	if(hop_count <= 0):
		collision_shape_2d.set_deferred("disabled", true)
		
		next_batch.emit()
		marker.play("Out")
			
		if(completed == true):
			gameover.emit()
		
		await marker.animation_finished

		queue_free()
	
func _on_timer_timeout():
	marker.play("Out")
	await marker.animation_finished
	queue_free()

func add_step_effect() -> void:
	var step_fx = ObjectReferences.STEP_EFFECTS.instantiate()
	get_parent().call_deferred("add_child", step_fx)
	step_fx.global_position = position
	
