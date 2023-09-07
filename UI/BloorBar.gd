extends Control

const full_heart_name = "FullHeart"
@export var health_per_heart : int = 5
@export var heart_cell_offset = 20

@onready var player : CharacterBody2D = get_tree().get_first_node_in_group("player")
var full_heart_template = preload("res://Character/Player/full_heart.tscn")
var empty_heart_template = preload("res://Character/Player/empty_heart.tscn")

var health : float

var heart_index : int

func _ready() -> void:
	var damageable : Damageable = player.find_child("Damageable")
	health = damageable.health
	damageable.connect("blood_bar_changed", _on_blood_bar_changed)
	var full_heart_count : int = health / health_per_heart
	init_bloor_bar(full_heart_count)
	
func _on_blood_bar_changed(new_health : float):
	if health > 0:
		var empty_heart_count : int = (health - new_health) / health_per_heart
		create_empty_heart(empty_heart_count)
		health = new_health
		
func init_bloor_bar(full_heart_count : int):
	for i in range(full_heart_count):
		var full_heart : Node = full_heart_template.instantiate()
		full_heart.name = full_heart_name + str(i)
		full_heart.global_position = Vector2(i * heart_cell_offset, 0)
		self.add_child(full_heart)
	heart_index = full_heart_count - 1
		

func create_empty_heart(empty_heart_count : int):
	for i in range(empty_heart_count):
		var hited_heart = self.get_child(heart_index)
		hited_heart.queue_free()
		var empty_heart : Node = empty_heart_template.instantiate()
		empty_heart.global_position = Vector2(heart_index * heart_cell_offset, 0)
		self.add_child(empty_heart)
		heart_index-=1
