extends Node2D

var current_batch_index: int = 0

func _ready():
	for i: Node2D in get_children(): # Batches
		for j: Area2D in i.get_children(): # Beats
			#print(j)
			j.connect("gameover", _on_game_over)
			j.connect("next_batch", _on_next_batch)

func _on_game_over() -> void:
	pass
	
func _on_next_batch() -> void:
	current_batch_index += 1
	get_child(current_batch_index).global_position = get_child(0).global_position
