extends TextureProgressBar

var colors: Array = ["ffffff00","ffffff"]
@onready var press_duration = $PressDuration
@export var press_duration_interval: float = .4
var uploaded_length: float
var uploaded_max_length: float

var accept_input: bool

func _ready():
	get_game_speed_tick()
	get_quality_press()

func _unhandled_input(event):
	if(Input.is_action_just_pressed("slow")):
		Engine.time_scale = .2
	if(Input.is_action_just_released("slow")):
		Engine.time_scale = 1

func _process(delta):
	on_set_max_value()
	#	Sync value
	#uploaded_duration = press_duration.time_left
	uploaded_length = value
	uploaded_max_length = max_value
	#value += press_duration.time_left
	if(get_game_speed().playing):
		value += delta / get_game_speed().count_before_emit
		print(get_game_speed().count_before_emit)
	if(value >= max_value):
		accept_input = false
	else:
		accept_input = true
	#if(press_duration.time_left > 0):
		#accept_input = true
	#else:
		#accept_input = false

#func if

func get_game_speed() -> Node:
	var game_speed: Node = get_tree().get_first_node_in_group("game_speed")
	return game_speed

func get_game_speed_tick() -> void:
	var game_speed: Node = get_tree().get_first_node_in_group("game_speed")
	game_speed.connect("tick", on_game_speed_tick)
	
func on_game_speed_tick() -> void:
	press_duration.stop()
	press_duration.start(press_duration_interval)
	#get_parent().get_node("Beat").play("Bounce")
	value = 0
	
func on_set_max_value() -> void:
	#var new_value: float = get_game_speed().beat_per_seconds * get_game_speed().count_before_emit
	var new_value: float = get_game_speed().beat_per_seconds 
	if(max_value != new_value):
		max_value = new_value
		press_duration.wait_time = new_value
	
func get_quality_press() -> void:
	var quality_press: Node = get_tree().get_first_node_in_group("quality_press")
	quality_press.connect("quality",_on_quality_press_emit)
	
func _on_quality_press_emit(type) -> void:
	var game_speed: Node = get_tree().get_first_node_in_group("game_speed")
	if(game_speed.track_end == false):
		$AnimationPlayer.stop()
		$AnimationPlayer.play("pop")
		$AnimatedSprite2D.play(str(type).to_lower())
		
