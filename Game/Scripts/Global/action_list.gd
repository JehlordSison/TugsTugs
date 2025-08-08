extends Node

enum Direction{Left, Right, Down, Up}
const ACTIONS: Array = ["move_left", "move_right", "move_down", "move_up"]
const ACTION_DIRECTIONS: Dictionary = {
	"move_left": Direction.Left, 
	"move_right": Direction.Right, 
	"move_down": Direction.Down, 
	"move_up": Direction.Up
}
