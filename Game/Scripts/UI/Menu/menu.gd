extends Control

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Game/Scenes/Levels/tutorial_level.tscn")

func _on_credits_button_pressed():
	get_tree().change_scene_to_file("res://Game/UI/Credits/credits.tscn")

func _on_story_button_pressed():
	get_tree().change_scene_to_file("res://Game/UI/Story/story.tscn")
