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
	#add_more_time_to_beat_meter()
	if(hop_count <= 0):
		collision_shape_2d.set_deferred("disabled", true)
		
		next_batch.emit()
		marker.play("Out")
			
		if(completed == true):
			gameover.emit()
		
		await marker.animation_finished

		queue_free()
		
#func add_more_time_to_beat_meter() -> void:
	#var beat_meter: TextureProgressBar = get_tree().get_first_node_in_group("beat_meter")
	#beat_meter.add_time()

#func 
	
#func spawn_new_tile() -> void:
	#var new_tile = ObjectReferences.TILE_FORM.instantiate()
	#get_parent().call_deferred("add_child", new_tile)
	#var random_x: Array = [-32,32]
	#var select_x: int = random_x[randi() % random_x.size()]
	#new_tile.global_position = Vector2(global_position.x + select_x, global_position.y)
	#print(select_x)
	
