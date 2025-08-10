extends Node

@onready var music = $Music

@export var song_bpm: float = 140
var beat_per_seconds: float = 60.0 / song_bpm
var song_position: float = 0.0
var beat_number: int = 0

signal tick

func _process(_delta: float):
	if music.playing:
		# Get the most accurate playback position
		song_position = music.get_playback_position() + AudioServer.get_time_since_last_mix()
		
		# Calculate the current beat number
		var new_beat = int(floor(song_position / beat_per_seconds))

		# Check if a new beat has just started
		if new_beat > beat_number:
			beat_number = new_beat
			# Trigger your game events here (e.g., spawn a note, move a character)
			tick.emit()
			send_tick()
			#print("Beat: ", beat_number)

func get_game_interface() -> CanvasLayer:
	var game_interface: CanvasLayer = get_tree().get_first_node_in_group("game_interface")
	return game_interface
	
func send_tick():
	$Metronome.play()
	get_game_interface().play_direction_key("")
