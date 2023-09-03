extends State

@export var knockback_velocity : float = 120
@export var friction : float = 120
@export var idle_state : State
@export var chase_state : State
@export var death_state : State

func state_process(delta: float) -> void:
	character.velocity = character.velocity.move_toward(Vector2.ZERO, friction * delta)
	if character.velocity == Vector2.ZERO:
		next_state = chase_state
		
func on_enter():
	animation_tree[PLAYBACK_PARAMETER_STR].travel("hurt")

func _on_damageable_on_state_hit(health, hitting_character) -> void:
	if health > 0:
		emit_signal("interrupt_state", self)
		var knockback_direction = hitting_character.global_position.direction_to(character.global_position)
		character.velocity = knockback_direction * knockback_velocity
	else:
		emit_signal("interrupt_state", death_state)
