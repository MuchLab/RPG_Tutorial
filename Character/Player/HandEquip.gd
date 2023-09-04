@tool
extends Sprite2D
@export var equipped_item : EquippableItem :
	set(next_equipped):
		equipped_item = next_equipped
		self.texture = equipped_item.texture

func _on_hitbox_body_entered(body: Node2D) -> void:
	if equipped_item.has_method("interact_with_body"):
		equipped_item.interact_with_body(body)
