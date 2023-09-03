extends State

class_name InvincibleState

@export var idle_state : State

func on_enter():
	next_state = idle_state
