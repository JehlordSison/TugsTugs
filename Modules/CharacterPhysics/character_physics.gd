extends Node
class_name CharacterPhysics

@export_group("Set Actor")
@export var actor: CharacterBody2D = get_parent()

@export_category("Physics Adjustments")
@export_group("Active")
@export var movement_speed: float = 100
@export var movement_max_speed: float = 100
@export var jump_force: int = 300
@export var gravity_force: int = -500
@export var dash_force: int = 300

@export_group("Passive")
@export var movement_acceleration: float = 300 ## 0-1 for Lerp Based, 0-200 for Delta Based
@export var movement_deceleration: float = .08 ## Fixed
@export var dash_time: float = .05

@export_group("Switches")
@export var can_move: bool = true
@export var can_jump: bool  = true
@export var can_dash: bool  = true
@export var enable_gravity: bool = true

func Movement(input: float, delta: float) -> void:
	if(input and can_move == true):
		if(abs(actor.velocity.x) <= abs(movement_max_speed)):
			actor.velocity.x += input * delta * movement_acceleration
			actor.velocity.x = clampf(actor.velocity.x, -movement_max_speed, movement_max_speed)
	else:
		actor.velocity.x = lerp(actor.velocity.x, 0.0, movement_deceleration)
		if(roundf(abs(actor.velocity.x)) == 0):
			actor.velocity.x = 0

func Movement_As_Lerp(input: float) -> void:
	if(input and can_move == true):
		if(abs(actor.velocity.x) < abs(movement_max_speed)):
			actor.velocity.x = lerp(actor.velocity.x, input * movement_speed, movement_acceleration)
	else:
		actor.velocity.x = lerp(actor.velocity.x, 0.0, movement_deceleration)
		if(roundf(abs(actor.velocity.x)) == 0):
			actor.velocity.x = 0

func Jump() -> void:
	if(can_jump):
		actor.velocity.y -= jump_force

func Dash(direction: Vector2)-> void:
	if(can_dash):
		can_dash = false
		enable_gravity = false
		actor.velocity = Vector2.ZERO
		actor.velocity.x += direction.x * dash_force
		await get_tree().create_timer(dash_time).timeout
		actor.velocity = Vector2.ZERO
		enable_gravity = true
		can_dash = true

func Gravity(delta: float) -> void:
	if!(actor.is_on_floor()):
		if(enable_gravity == true):
			actor.velocity.y -= gravity_force * delta
		
func Knockup(direction: Vector2, amount: float) -> void:
	actor.velocity.x += direction.x * amount
