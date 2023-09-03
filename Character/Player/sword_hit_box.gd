extends Area2D

signal on_hit_body()

func _on_body_entered(body: Node2D) -> void:
	for child in body.get_children():
		if child is Damageable:
			emit_signal("on_hit_body")
