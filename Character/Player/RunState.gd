extends State

@export var max_speed = 125
@export var acceleration = 25
@export var idle_state : State
@export var swing_state : State
@export var roll_state : State

func state_process(_delta : float):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction != Vector2.ZERO:
		animation_tree.set("parameters/run/blend_position", direction)
		character.velocity = character.velocity.move_toward(direction * max_speed, acceleration)
		default_direction = direction
	else:
		next_state = idle_state
		
func state_input(event : InputEvent):
	if event.is_action_pressed("roll"):
		next_state = roll_state
	if event.is_action_pressed("swing"):
		next_state = swing_state
		
func on_enter():
	animation_tree[PLAYBACK_PARAMETER_STR].travel("run")
