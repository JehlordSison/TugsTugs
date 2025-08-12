extends CanvasLayer

var score: int 
var tiles_hit: int
var combo: int

@export var next_scene: String

func _on_game_speed_track_finished():
	show()

func _on_retry_button_pressed():
	GameHandler.GameRestart()

func _on_menu_button_pressed():
	GameHandler.GameMenu

func _on_next_button_pressed():
	get_tree().change_scene_to_file(next_scene)
