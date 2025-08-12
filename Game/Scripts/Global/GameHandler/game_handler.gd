extends Node

enum GameState{Menu, Playing, Paused, GameOver}

@export var game_state: GameState = GameState.Menu : set = _on_update_game_state

var scores: int
#var score_multiplier: int = 1

func _on_update_game_state(val):
	pass

func _ready():
	GameState

func GamePlaying() -> void:
	get_tree().paused = false
	
func GamePause() -> void:
	get_tree().paused = true
	
func GameOver()	-> void:
	pass
