extends DamageEffect

class_name ImmediateDamageEffect
	

@export var min_damage : int = 1
@export var max_damage : int = 1

func take_damage_on_health(damageable : Damageable):
	damageable.health-=randi_range(min_damage, max_damage)
