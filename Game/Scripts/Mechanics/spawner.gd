extends Node2D
var tiles: Array = [16, 48, 80, 112, 144, 176, 208, 240, 272, 304, 336, 368, 400, 432]
var current_tile: int 
@export var sequence: Array = []

#@export var sequence: Array = [
	#7 ,8 ,9, 8, 7, 6, 7, 8, 9, 8, 
	#7, 6, 7, 8, 9, 8, 7, 6, 7, 8, 
	#9, 8, 7, 8, 7, 8, 7, 8, -1, -1, 
	#9, 8, 7, 6, 5, 6, 5, 6, 5, 4, 
	#5, 4, 5, 4, 3, 2, 1, 2, 3, 4, 
	#5, 6, 5, 4, 5, 6, 7, 8, 9, 8, 7, 6, 5, 4, 3, 2, 1, 2, 3, 4, 5, 6, 7, 8, 9, 8, 7, 6, 5, 4, 3, 2, 1, 2, 3, 4, 5, 6, 5, 6, 5, 7, 8, 7, 8, 9, 8, 9, 8, 7, 8, 7, 8, 6, 5, 6, 5, 4, 5, 4, 5, 3, 2, 3, 2, 3, 4, 5, 6, 7, 8, 9, 8, 7, 6, 5, 4, 3, 2, 1, 2, 3, 4, 5, 6, 7, 8, 9, 8, 7, 6, 5, 4, 5, 6, 5, 4, 5, 6, 7, 8, 9,10]

# Direction detection variables
enum Direction { NONE, LEFT, RIGHT }
var current_direction: Direction = Direction.NONE
var previous_tile_index: int = -1
signal direction_changed(new_direction: Direction)

@onready var arrow_indicator = $ArrowIndicator

func _ready():
	get_game_speed()

func get_game_speed() -> void:
	var game_speed: Node = get_tree().get_first_node_in_group("game_speed")
	game_speed.connect("tick", on_game_speed_tick)

func on_game_speed_tick() -> void:
	if(sequence.size() > 0):
		if(sequence[0] != -1):
			if(tile_forms_exceeded() == false):
				move_to(sequence[0])
		else:
			arrow_indicator.play("none")
			sequence.remove_at(0)

func move_to(pos: int) -> void:
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", Vector2(tiles[pos], global_position.y), .09)
	tween.stop()
	tween.play()
	await tween.finished
	spawn_tile(tiles[pos])
	sequence.remove_at(0)
	
	# Update previous tile index after moving
	previous_tile_index = pos
	
	# Now predict the NEXT direction after spawning
	predict_next_direction()

func predict_next_direction() -> void:
	if sequence.size() > 0 and previous_tile_index != -1:
		# Find the next non-(-1) value in the sequence
		var next_tile_index = -1
		for i in range(sequence.size()):
			if sequence[i] != -1:
				next_tile_index = sequence[i]
				break
		
		if next_tile_index != -1:
			var old_direction = current_direction
			
			if next_tile_index > previous_tile_index:
				current_direction = Direction.RIGHT
			elif next_tile_index < previous_tile_index:
				current_direction = Direction.LEFT
			else:
				current_direction = Direction.NONE
			
			# Emit signal if direction changed
			if old_direction != current_direction:
				direction_changed.emit(current_direction)
				#print("Next direction will be: ", direction_to_string(current_direction))
		else:
			# No more valid moves, set to NONE
			if current_direction != Direction.NONE:
				current_direction = Direction.NONE
				direction_changed.emit(current_direction)
				#print("Sequence ended, direction: NONE")


func direction_to_string(dir: Direction) -> String:
	match dir:
		Direction.LEFT:
			return "LEFT"
		Direction.RIGHT:
			return "RIGHT"
		Direction.NONE:
			return "NONE"
		_:
			return "UNKNOWN"

func get_current_direction() -> Direction:
	return current_direction

func is_moving_left() -> bool:
	return current_direction == Direction.LEFT

func is_moving_right() -> bool:
	return current_direction == Direction.RIGHT

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

func spawn_tile(pos: int) -> void:
	var tile = ObjectReferences.TILE_FORM.instantiate()
	get_parent().call_deferred("add_child", tile)
	tile.global_position = Vector2(pos, global_position.y)

func tile_forms_exceeded() -> bool:
	var tile_form_count = get_tree().get_nodes_in_group("tile_forms").size()
	if(tile_form_count >= 7):
		return true
	else:
		return false
		
func get_player_position() -> int:
	var player: CharacterBody2D = get_tree().get_first_node_in_group("player")
	var snapped_player_x = snap_to_closest_tile(player.global_position.x)
	return snapped_player_x

func _on_direction_changed(new_direction):
	match new_direction:
		0:
			arrow_indicator.play("none")
		1:
			arrow_indicator.play("left")
		2:
			arrow_indicator.play("right")
