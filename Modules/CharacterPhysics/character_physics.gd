extends Node
class_name CharacterPhysics

@export_group("Set Actor")
@export var actor: CharacterBody2D = get_parent()

@export_category("Physics Adjustments")
@export_group("Active")
@export var movement_speed: float = 75
@export var movement_max_speed: float = 80
@export var jump_force: int = 225
@export var gravity_force: int = -750
@export var hop_force: int = 150

var move_count: int = 1
var reset_move_count: int = move_count

@export_group("Passive")
@export var move_snap: int = 16
@export var snap_rate: int = 5

@export_group("Switches")
@export var can_move: bool = true
@export var can_decelerate: bool  = true
@export var can_jump: bool  = true
@export var enable_gravity: bool = true

func _physics_process(delta):
	Snap(delta)
	if(actor.is_on_floor()):
		move_count = reset_move_count
	
	if(actor.velocity.y > 0):
		gravity_force = -1000
	else:
		gravity_force = -780

func Movement_Snap(input: float) -> void:
	if(input and can_move == true):
		if(move_count > 0):
			actor.velocity.x += input * movement_speed 
			actor.velocity.y -= hop_force
			move_count -= 1
	
func Snap(delta: float) -> void:
	if(actor.is_on_floor()):
		var target_pos = round(actor.global_position.x/ move_snap) * move_snap
		actor.velocity.x = 0
		if(abs(actor.global_position.x - target_pos) > .5):
			actor.global_position.x = lerp(actor.global_position.x, target_pos, snap_rate * delta)

func Jump() -> void:
	if(can_jump):
		if(move_count > 0):
			actor.velocity.y -= jump_force
			move_count -= 1

func Gravity(delta: float) -> void:
	if!(actor.is_on_floor()):
		if(enable_gravity == true):
			actor.velocity.y -= gravity_force * delta
	#if(actor.velocity.y < 0):
		#gravity_force = -1000
	#else:
		#gravity_force = -750
		
		
func Knockup(direction: Vector2, amount: float) -> void:
	actor.velocity.x += direction.x * amount
