extends Area2D

signal on_hit

@export var damage : int = 10
@export var hitting_character : CharacterBody2D


func _on_area_entered(area: Area2D) -> void:
	emit_signal("on_hit")
	area.emit_signal("on_hurt", damage, hitting_character)
