extends Node

var press_sequence: Array = []

# Timing windows (as percentage of beat meter duration)
@export var perfect_threshold: float = 0.25 
@export var good_threshold: float = 0.5   

signal quality(type: String)

func _ready():
	get_game_speed_tick()

func get_game_speed_tick() -> void:
	var game_speed: Node = get_tree().get_first_node_in_group("game_speed")
	game_speed.connect("tick", on_game_speed_tick)
	
func on_game_speed_tick() -> void:
	add_entity("Beat")

func get_beat_meter() -> TextureProgressBar:
	var beat_meter: TextureProgressBar = get_tree().get_first_node_in_group("beat_duration")
	return beat_meter
	
func _on_controls_has_input(dir):
	add_entity(dir)
	
func add_entity(who: String) -> void:
	press_sequence.append(who)
	
	if who != "Beat":
		# Player input occurred, check quality immediately
		press_quality(who)
	
	# Keep arrays manageable
	if press_sequence.size() > 5:
		press_sequence = press_sequence.slice(-3)

func press_quality(input_dir: String) -> String:
	var beat_meter = get_beat_meter()
	
	# Check beat meter state
	var is_beat_active = beat_meter.accept_input
	var time_remaining = beat_meter.uploaded_duration
	var max_duration = beat_meter.press_duration_interval
	var result: String
	
	# Case 1: No beat is currently active (beat meter not running)
	if(is_beat_active == false):
		if time_remaining <= 0:
			# Beat meter has finished or hasn't started yet
			#print("Miss - No active beat window, Direction: ", input_dir)
			result = "Miss"
			quality.emit(result)
			return "Miss"
		else:
			# This case shouldn't happen with your logic, but just in case
			#print("Early - Beat not ready, Direction: ", input_dir)
			return "Early"
	
	# Case 2: Beat is active, check timing quality within the window
	var time_elapsed = max_duration - time_remaining
	var elapsed_percentage = time_elapsed / max_duration

	# Perfect: Hit within first 25% of beat meter duration
	if elapsed_percentage <= perfect_threshold:
		result = "Perfect"
	elif elapsed_percentage > perfect_threshold and elapsed_percentage <= good_threshold:
		result = "Good"
	else:
		result = "Late"
		
	quality.emit(result)
	#print(result, " - Elapsed: ", elapsed_percentage * 100, "% of beat meter, Direction: ", input_dir)
	return result
