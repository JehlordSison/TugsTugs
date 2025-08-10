extends TextureProgressBar
@onready var game_over_timer = $GameOverTimer

var colors: Array = ["00c500", "b3c200", "ff4a00", "ff0000"]

func _ready():
	start_beat_meter()

func _process(_delta):
	var select_color: Color
	#	Colors
	if(value >= max_value * .75):
		select_color = colors[0]
	elif(value >= max_value * .5 and value < max_value * .75):
		select_color = colors[1]
	elif(value >= max_value * .25 and value < max_value * .5):
		select_color = colors[2]
	elif(value < max_value * .25):
		select_color = colors[3]
	
	self_modulate = lerp(self_modulate, Color(select_color), .8)
	value = game_over_timer.time_left

func start_beat_meter() -> void:
	game_over_timer.start()

func add_time(val: float = .8) -> void:
	start_beat_meter()
	game_over_timer.wait_time = val
