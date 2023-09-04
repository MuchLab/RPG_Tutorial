extends Marker2D
@onready var hand_equip: Sprite2D = $HandEquip

func _ready() -> void:
	hand_equip.visible = false
