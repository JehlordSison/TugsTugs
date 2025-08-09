extends Timer

func get_game_interface() -> CanvasLayer:
	var game_interface: CanvasLayer = get_tree().get_first_node_in_group("game_interface") 
	return game_interface
	
func _on_timeout():
	get_game_interface().play_direction_key("")
