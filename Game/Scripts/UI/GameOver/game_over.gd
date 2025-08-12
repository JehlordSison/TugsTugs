extends CanvasLayer

var score: int 
var tiles_hit: int
var combo: int

func _on_game_speed_track_finished():
	show()
