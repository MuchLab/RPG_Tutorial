@tool
extends Sprite2D

class_name HandEquip

@export var equipped_character : CharacterBody2D
@export var equipped_item : EquippableItem :
	set(next_equipped):
		equipped_item = next_equipped
		self.texture = equipped_item.texture
		equipped_item.character = equipped_character
func _ready() -> void:
	equipped_item.character = equipped_character

func _on_hitbox_body_entered(body: Node2D) -> void:
	if equipped_item.has_method("interact_with_body"):
		equipped_item.interact_with_body(body)


func _on_hitbox_area_entered(area: Area2D) -> void:
	if equipped_item.has_method("interact_with_area"):
		equipped_item.interact_with_area(area)
