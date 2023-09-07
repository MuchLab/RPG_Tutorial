extends State

@export var max_speed = 75
@export var acceleration = 25
@export var idle_state : State

func state_process(delta):
	var direction = character.global_position.direction_to(character.orignal_position)
	if character.global_position.distance_squared_to(character.orignal_position) > 4:
		character.velocity = character.velocity.move_toward(direction * max_speed, acceleration)
	else:
		character.velocity = Vector2.ZERO
		character.global_position = character.orignal_position
		next_state = idle_state
