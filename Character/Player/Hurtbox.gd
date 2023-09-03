extends Area2D

signal on_hurt(damage : int, hitting_character : CharacterBody2D)

func _ready() -> void:
	EventBus.connect("on_monitorable_changed", _on_monirable_changed)

	
func _on_monirable_changed(is_monitorable : bool):
	self.set_deferred("monitorable", is_monitorable)
