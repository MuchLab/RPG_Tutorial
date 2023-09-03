extends ResourceNode
@onready var sprite: Sprite2D = $Sprite2D

@export var interval_time = 0.5
@export var flash_duration = 2
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_player_detector_body_entered(body: Node2D) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate:a", 0.5, 0.3)
	print(sprite.modulate.a)


func _on_player_detector_body_exited(body: Node2D) -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(sprite, "modulate:a", 1, 0.3)

func _on_hurt_box_on_hurt(damage, hitting_character) -> void:
	animation_player.play("cuted")
