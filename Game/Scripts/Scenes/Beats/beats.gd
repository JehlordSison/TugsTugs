extends Node2D

@onready var sheet = $Sheet

func _ready():
	for i in get_children(): # Batches
		if(i is Node2D):
			for j: Area2D in i.get_children(): # Beats
				#print(j)
				j.connect("gameover", _on_game_over)
				j.connect("next_batch", _on_next_batch)

func _on_game_over() -> void:
	pass
	
func _on_next_batch() -> void:
	sheet.global_position.y -= 16
	#animation_player.play("next")
	#await get_tree().create_timer(.2).timeout
	#animation_player.pause()
	
