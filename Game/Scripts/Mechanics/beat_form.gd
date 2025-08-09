extends Area2D
@onready var audio_stream_player = $AudioStreamPlayer
@onready var collision_shape_2d = $CollisionShape2D
@onready var marker = $Marker

@export var play_marker: bool = true
@export var start: bool = false ## Start the beat
@export var end: bool = false ## End the beat
@export var completed: bool = false ## Beats Finishes all

signal next_batch
signal gameover

func _ready():
	beat_start()

func _on_detect_player_body_entered(_body):
	beat_selected()

func _on_body_entered(_body):
	collision_shape_2d.set_deferred("disabled", true)
	audio_stream_player.play()
	
	if(play_marker == true):
		marker.play("Out")
		
	if(end == true):
		next_batch.emit()
		
	if(completed == true):
		gameover.emit()
		
	await audio_stream_player.finished
	queue_free()
			
func beat_selected() -> void:
	if(play_marker == true):
		marker.play("In")
		
func beat_start() -> void:
	if(start == true):
		$Detect_player/CollisionShape2D.set_deferred("disabled", true)
		marker.play("In")
	
	
	
