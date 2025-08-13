extends AudioStreamPlayer
@onready var music = $"."
@export var song_bpm: float = 140
var beat_per_seconds: float = 60.0 / song_bpm
var song_position: float = 0.0
var previous_song_position: float = 0.0
var beat_number: int = 0

@export var song_is_looped: bool = false

signal tick
var count_before_emit: int = 2
var reset_count_before_emit: int = count_before_emit
@export var update_count: int = count_before_emit: set = on_count_update
signal count_before_emit_changed(val: int)

var track_end: bool = false
var music_has_started: bool = false  # NEW: Track if music was ever started
signal track_finished

func on_count_update(val):
	count_before_emit = val
	reset_count_before_emit = count_before_emit
	count_before_emit_changed.emit(val)

func _ready():
	beat_per_seconds = 60.0 / song_bpm
	reset_count_before_emit = count_before_emit
	
	# Alternative: Connect to the built-in finished signal
	connect("finished", on_music_finished)

func _process(delta: float):
	if music.playing:
		# Mark that music has started
		if not music_has_started:
			music_has_started = true
			print("Music started!")
			
		song_position = music.get_playback_position() + AudioServer.get_time_since_last_mix()
		
		# Check for song end WHILE playing (before it stops)
		if song_remaining_time() <= 0.1 and not track_end:  # 0.1 second buffer
			if(song_is_looped == false):
				track_finished.emit()
				track_end = true
				print("Track ending soon!")
		
		if song_position < previous_song_position:
			# Song looped, reset beat tracking
			beat_number = 0
			track_end = false  # Reset track_end if song loops
		
		previous_song_position = song_position
	
		# Calculate the current beat number
		var new_beat = int(floor(song_position / beat_per_seconds))
		if new_beat > beat_number:
			beat_number = new_beat
			# Trigger shit here
			count_before_emit -= 1
			if count_before_emit == 0:
				tick.emit()
				count_before_emit = reset_count_before_emit
				#print("emitt")
			#print("Beat: ", beat_number)
		#print(count_before_emit)
	else:
		# Music stopped playing - BUT only if it was started before
		if music_has_started and not track_end:
			if(song_is_looped == false):
				print("Music stopped after being started!")
				track_finished.emit()
				track_end = true

func on_music_finished():
	# Built-in signal for when audio finishes naturally
	if not track_end:
		track_finished.emit()
		track_end = true
		print("Music finished via signal!")

# Manual control functions
func start_music():
	"""Manually start the music"""
	music.play()
	music_has_started = true
	track_end = false  # Reset track end when starting
	print("Music manually started!")

func restart_music():
	"""Restart the music from the beginning"""
	music.stop()
	beat_number = 0
	song_position = 0.0
	previous_song_position = 0.0
	music_has_started = false
	track_end = false
	count_before_emit = reset_count_before_emit
	music.play()
	music_has_started = true
	print("Music restarted!")

func is_music_started() -> bool:
	"""Check if music has ever been started"""
	return music_has_started

func song_remaining_time() -> float:
	if stream and stream.get_length() > 0:
		var remaining_time: float = stream.get_length() - song_position
		return max(0.0, remaining_time)  # Ensure it doesn't go negative
	return 0.0
		
func get_game_interface() -> CanvasLayer:
	var game_interface: CanvasLayer = get_tree().get_first_node_in_group("game_interface")
	return game_interface
	
func force_end_game():
	music.stop()
	if not track_end:
		track_finished.emit()
		track_end = true

func fade_out_and_end(fade_duration: float = 1.0):
	var tween = get_tree().create_tween()
	tween.tween_property(music, "volume_db", -80, fade_duration)
	await tween.finished
	force_end_game()

func stop_music_only():
	music.stop()

func pause_music():
	music.stream_paused = true

func resume_music():
	music.stream_paused = false
