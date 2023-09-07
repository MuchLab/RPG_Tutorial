extends State

class_name HurtState

@export var knockback_velocity : float = 150
@export var friction : float = 50
@export var idle_state : State
@export var death_state : State
@export var invincible_duration : float = 2.0
@onready var run_request_timer: Timer = $RunRequestTimer
@onready var invincible_timer: Timer = $InvincibleTimer

var hit_effect_template = preload("res://Effect/hit_effect.tscn")


func state_process(delta: float) -> void:
	character.velocity = character.velocity.move_toward(Vector2.ZERO, friction * delta)
	if character.velocity == Vector2.ZERO:
		next_state = idle_state
	var direction = Input.get_vector("left", "right", "up", "down")
	if direction != Vector2.ZERO and run_request_timer.is_stopped():
		next_state = idle_state

func create_hit_effect():
	var hit_effect = hit_effect_template.instantiate()
	var main_scene = get_tree().current_scene
	main_scene.add_child(hit_effect)
	hit_effect.global_position = character.global_position

func into_invincible():
	invincible_timer.start(invincible_duration)
	EventBus.emit_signal("on_monitorable_changed", false)
	var invincible_tween = get_tree().create_tween()
	var interval_time = 0.25
	invincible_tween.tween_property(character.sprite, "material:shader_parameter/flash_state", 1, interval_time)
	invincible_tween.tween_property(character.sprite, "material:shader_parameter/flash_state", 0, interval_time)
	invincible_tween.set_loops(invincible_duration / (interval_time * 2))
	
func _on_invincible_timer_timeout() -> void:
	EventBus.emit_signal("on_monitorable_changed", true)
	var invincible_tween = get_tree().create_tween()
	invincible_tween.stop()


func _on_damageable_state_hurt_trigered(health, hitting_character) -> void:
	if health > 0:
		create_hit_effect()
		into_invincible()
		
		run_request_timer.start()
		emit_signal("interrupt_state", self)
		if hitting_character:
			var knockback_direction = hitting_character.global_position.direction_to(character.global_position)
			character.velocity = knockback_direction * knockback_velocity
