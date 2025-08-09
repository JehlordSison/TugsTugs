extends CanvasLayer

@onready var arrow_animation = $Panel/ArrowAnimation
@onready var h_box_container = $Panel/HBoxContainer

func play_direction_key(dir: String) -> void:
	match dir: 
		"Right":
			arrow_animation.play("right")
		"Left":
			arrow_animation.play("left")
		"Up":
			arrow_animation.play("up")
		"":
			arrow_animation.play("none")
	
	await arrow_animation.animation_finished
	arrow_animation.play("none")

func add_arrow_queue(dir: String) -> void:
	var Left := ObjectReferences.LEFT_ARROW_QUEUE.instantiate()
	var Right := ObjectReferences.RIGHT_ARROW_QUEUE.instantiate()
	var Up := ObjectReferences.UP_ARROW_QUEUE.instantiate()
	
	match dir: 
		"Right":
			h_box_container.add_child(Right)
		"Left":
			h_box_container.add_child(Left)
		"Up":
			h_box_container.add_child(Up)
			
func delete_arrow_queue(index: int) -> void:
	if(h_box_container.get_children().size() > 0):
		h_box_container.get_child(index).queue_free()
	
	
	
	
	
