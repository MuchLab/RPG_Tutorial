extends ProgressBar

@export var damageable : Damageable
@onready var total_health = damageable.health

func _process(delta: float) -> void:
	value = (damageable.health / total_health) * 100
	
	
