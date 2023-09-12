extends State

@onready var switch_timer: Timer = $SwitchTimer

@export var wander_state : State
@export var wander_duration = 3
@export var should_resume : bool = false


func on_enter():
	character.velocity = Vector2.ZERO
	animation_tree[PLAYBACK_PARAMETER_STR].travel("idle")
	switch_timer.start(randi_range(1, wander_duration))
		
func _on_switch_timer_timeout() -> void:
	emit_signal("interrupt_state", wander_state)
	
func on_exit():
	switch_timer.stop()
