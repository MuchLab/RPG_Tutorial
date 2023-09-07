extends ProgressBar

var total_health : float
var current_health : float
func _process(delta: float) -> void:
	value = (current_health / total_health) * 100

func _on_hurtbox_blood_bar_initialized(health) -> void:
	total_health = health
	current_health = health



func _on_damageable_blood_bar_changed(health) -> void:
	current_health = health
