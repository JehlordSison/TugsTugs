extends AudioStreamPlayer

@onready var music = $"."
@export var song_bpm: float = 140
var beat_per_seconds: float = 60.0 / song_bpm
var song_position: float = 0.0
var previous_song_position: float = 0.0
var beat_number: int = 0

signal tick
var count_before_emit: int = 2
var reset_count_before_emit: int = count_before_emit
@export var update_count: int = count_before_emit: set = on_count_update

var track_end: bool = false
signal track_finished

func on_count_update(val):
	count_before_emit = val
	reset_count_before_emit = count_before_emit

func _ready():
	beat_per_seconds = 60.0 / song_bpm
	reset_count_before_emit = count_before_emit

func _process(_delta: float):
	#	Update
	
	if music.playing:
		song_position = music.get_playback_position() + AudioServer.get_time_since_last_mix()
		
		if song_position < previous_song_position:
			# Song looped, reset beat tracking
			beat_number = 0
		
		previous_song_position = song_position
	
		# Calculate the current beat number
		var new_beat = int(floor(song_position / beat_per_seconds))
		if new_beat > beat_number:
			beat_number = new_beat
			# Trigger shit here
			count_before_emit -= 1
			if count_before_emit == 0:
				tick.emit()
				send_tick()
				count_before_emit = reset_count_before_emit
				#print("emitt")
			#print("Beat: ", beat_number)
		#print(count_before_emit)
	else:
		if (song_remaining_time() <= 0):
			if(track_end == false):
				track_finished.emit()
				track_end = true
			
func song_remaining_time() -> float:
	var remaining_time: float = stream.get_length()	- song_position
	#print(remaining_time)
	return remaining_time
		
func get_game_interface() -> CanvasLayer:
	var game_interface: CanvasLayer = get_tree().get_first_node_in_group("game_interface")
	return game_interface
	
func send_tick():
	get_game_interface().play_direction_key("")
