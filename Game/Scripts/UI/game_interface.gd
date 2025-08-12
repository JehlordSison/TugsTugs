extends CanvasLayer

@onready var arrow_animation = $Panel/ArrowAnimation
@onready var h_box_container = $Panel/HBoxContainer
@onready var animation_player = $Panel/AnimationPlayer

@onready var score_label = $ScoreLabel

var score: int = 0: set = _on_update_score

func _on_update_score(val):
	score = val
	score_label.text = str("Score: ",val)
	
func _ready():
	get_game_speed()
	
func play_direction_key(dir: String) -> void:
	match dir: 
		"Right":
			arrow_animation.play("right")
			animation_player.play("slide")
		"Left":
			arrow_animation.play("left")
			animation_player.play("slide")
		"Up":
			arrow_animation.play("up")
			animation_player.play("slide")
		"Down":
			arrow_animation.play("down")
			animation_player.play("slide")
		"":
			if(arrow_animation.animation == "none"):
				arrow_animation.play("none")
				animation_player.play("RESET")
			
	await arrow_animation.animation_finished
	arrow_animation.play("none")

func add_arrow_queue(dir: String) -> void:
	var Left := ObjectReferences.LEFT_ARROW_QUEUE.instantiate()
	var Right := ObjectReferences.RIGHT_ARROW_QUEUE.instantiate()
	var Up := ObjectReferences.UP_ARROW_QUEUE.instantiate()
	var Down := ObjectReferences.DOWN_ARROW_QUEUE.instantiate()
	
	match dir: 
		"Right":
			h_box_container.add_child(Right)
		"Left":
			h_box_container.add_child(Left)
		"Up":
			h_box_container.add_child(Up)
		"Down":
			h_box_container.add_child(Down)
			
func delete_arrow_queue(index: int) -> void:
	if(h_box_container.get_children().size() > 0):
		h_box_container.get_child(index).queue_free()
	
func get_game_speed() -> void:
	var game_speed = get_tree().get_first_node_in_group("game_speed")
	game_speed.connect("track_finished", _on_game_over)

func _on_game_over() -> void:
	hide_elements()
	get_player()
	#var game_over_screen = ObjectReferences.GAME_OVER_SCREEN.instantiate()
	#get_tree().root.add_child(game_over_screen)
	
func get_player() -> void:
	var player = get_tree().get_first_node_in_group("player")
	player.get_node("CharacterPhysics").can_move = false
	player.get_node("CharacterPhysics").can_jump = false

func hide_elements() -> void:
	$BeatDuration.hide()
	$Beat.hide()
