extends Node

enum GameState{Menu, Playing, Paused, GameOver}

@export var game_state: GameState = GameState.Menu

var scores: int

func _ready():
	GameState

func GamePlaying() -> void:
	
	get_tree().paused = false
	
func GamePause() -> void:
	get_tree().paused = true
	
func GameOver()	-> void:
	pass
