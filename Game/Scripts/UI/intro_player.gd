extends AnimationPlayer

@onready var animated_sprite_2d = $AnimatedSprite2D
@onready var animated_sprite_2d_2 = $AnimatedSprite2D2

signal start
@export var can_autoplay: bool = true

func _ready():
	connect("start", _on_start)
	if(can_autoplay == true):
		play("intro")

func _on_animation_finished(anim_name):
	if(anim_name == "intro"):
		animated_sprite_2d.play("shine")
		animated_sprite_2d_2.play("shine")
		$Shine.play()
		await animated_sprite_2d.animation_finished
		play("outro")
	if(anim_name == "outro"):
		start.emit()

func _on_start() -> void:
	get_game_speed()
	pass
	
func get_game_speed() -> void:
	var game_speed = get_tree().get_first_node_in_group("game_speed")
	game_speed.playing = true 
	
	
	
