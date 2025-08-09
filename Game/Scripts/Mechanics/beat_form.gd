extends Area2D
@onready var audio_stream_player = $AudioStreamPlayer

func _on_body_entered(_body):
	audio_stream_player.play()
	await audio_stream_player.finished
	queue_free()
