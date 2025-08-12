extends TextureProgressBar

var colors: Array = ["ffffff00","ffffff"]
@onready var press_duration = $PressDuration
@export var press_duration_interval: float = .4
var uploaded_duration: float

var accept_input: bool

func _ready():
	set_max_value()
	get_game_speed_tick()
	get_quality_press()

func _process(_delta):
	#	Sync value
	uploaded_duration = press_duration.time_left
	value = press_duration.time_left
	if(press_duration.time_left > 0):
		accept_input = true
	else:
		accept_input = false
		
func set_max_value() -> void:
	max_value = press_duration_interval

func get_game_speed_tick() -> void:
	var game_speed: Node = get_tree().get_first_node_in_group("game_speed")
	game_speed.connect("tick", on_game_speed_tick)
	
func on_game_speed_tick() -> void:
	press_duration.stop()
	press_duration.start(press_duration_interval)
	get_parent().get_node("Beat").play("Bounce")


func get_quality_press() -> void:
	var quality_press: Node = get_tree().get_first_node_in_group("quality_press")
	quality_press.connect("quality",_on_quality_press_emit)
	
func _on_quality_press_emit(type) -> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("pop")
	$AnimatedSprite2D.play(str(type).to_lower())
	
