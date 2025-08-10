extends Area2D
@onready var audio_stream_player = $AudioStreamPlayer
@onready var collision_shape_2d = $CollisionShape2D
@onready var marker = $Marker

@export var play_marker: bool = true
@export var completed: bool = false ## Beats Finishes all

signal next_batch
signal gameover ## Connect this to gameMachine

func _ready():
	marker.play("In")

func _on_body_entered(_body):
	collision_shape_2d.set_deferred("disabled", true)
	audio_stream_player.play()
	
	add_more_time_to_beat_meter()
	
	next_batch.emit()
	
	marker.play("Out")
		
	if(completed == true):
		gameover.emit()
	
	await audio_stream_player.finished
	if(play_marker == true):
		await marker.animation_finished
		queue_free()
	else:
		queue_free()
		
func add_more_time_to_beat_meter() -> void:
	var beat_meter: TextureProgressBar = get_tree().get_first_node_in_group("beat_meter")
	beat_meter.add_time()
	
