extends State

@export var wander_range = 32
@export var acceleration = 25
@export var max_speed = 75
@export var idle_state : State
@export var target_position_range = 4

var target_position : Vector2 = Vector2.ZERO


func on_enter():
	animation_tree[PLAYBACK_PARAMETER_STR].travel("fly")
	target_position = initialize_target_position()
	
func on_exit():
	character.velocity = Vector2.ZERO

func state_process(delta):
	var target_direction = update_target_direction()
	if character.global_position.distance_squared_to(target_position) > target_position_range:
		character.velocity = character.velocity.move_toward(target_direction * max_speed, acceleration)
	else:
		emit_signal("interrupt_state", idle_state)
		
func initialize_target_position():
	target_position = Vector2(character.orignal_position.x + randi_range(-wander_range, wander_range), character.orignal_position.y + randi_range(-wander_range, wander_range))	
	return target_position

func update_target_direction():
	var target_direction = character.global_position.direction_to(target_position)
	return target_direction





