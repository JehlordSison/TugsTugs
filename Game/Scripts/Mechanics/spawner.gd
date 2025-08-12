extends Node2D

var tiles: Array = [16, 48, 80, 112, 144, 176, 208, 240, 272, 304, 336, 368, 400, 432]
var current_tile: int 
var beat_count: int = 4
var previous_tile: int = -1

func _ready():
	get_game_speed()
	move_to(7)

func get_game_speed() -> void:
	var game_speed: Node = get_tree().get_first_node_in_group("game_speed")
	game_speed.connect("tick", _on_game_speed_tick)

func _on_game_speed_tick() -> void:
	print(global_position.x)
	
	# Create array of available indices (excluding the previous one)
	var available_indices: Array = []
	for i in range(tiles.size()):
		if i != previous_tile:
			available_indices.append(i)
	
	# Select random index from available options
	var selected_index: int = available_indices[randi() % available_indices.size()]
	
	# Update previous tile index
	previous_tile = selected_index
	
	# Move to the selected tile
	move_to(selected_index)
	
#
#func get_player_position() -> void:
	#var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
#
	#print(player.global_position.x)
	## Snap player position to closest tile value, then offset
	#var snapped_player_x = snap_to_closest_tile(player.global_position.x)
	##global_position.x = snapped_player_x + 32
	#
	#var tween: Tween = get_tree().create_tween()
	#tween.tween_property(self, "global_position", Vector2(snapped_player_x + 32,global_position.y),.09 )
	#tween.stop()
	#tween.play()

func move_to(pos: int) -> void:
	tiles[pos]
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", Vector2(tiles[pos],global_position.y),.09 )
	tween.stop()
	tween.play()
	await tween.finished
	spawn_tile(tiles[pos])

func snap_to_closest_tile(pos: float) -> float:
	var closest_tile = tiles[0]
	var min_distance = abs(pos - closest_tile)
	
	for tile in tiles:
		var distance = abs(pos - tile)
		if distance < min_distance:
			min_distance = distance
			closest_tile = tile
			current_tile = tiles.find(tile)
	
	return closest_tile

func spawn_tile(pos: float) -> void:
	var tile = ObjectReferences.TILE_FORM.instantiate()
	tile.global_position = Vector2(pos, global_position.y) 
	get_parent().call_deferred("add_child", tile)
