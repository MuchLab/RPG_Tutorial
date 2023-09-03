extends Node

class_name Damageable

signal on_state_hit(health : int, hitting_character : CharacterBody2D)
signal on_blood_bar_changed(damage : int)
@export var health : float = 20.0

func _on_hurtbox_on_hurt(damage, hitting_character) -> void:
	health -= damage
	emit_signal("on_state_hit", health, hitting_character)
	emit_signal("on_blood_bar_changed", damage)
