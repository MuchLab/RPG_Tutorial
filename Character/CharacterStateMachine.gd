extends Node

class_name CharacterStateMachine

@export var current_state : State
@export var character : CharacterBody2D
@export var animation_tree : AnimationTree
@export var disabled : bool = false


var invincible_tween : Tween

var states : Array[State]

func _ready() -> void:
	if disabled:
		self.process_mode = PROCESS_MODE_DISABLED
	for child in get_children():
		if child is State:
			states.append(child)
			child.character = character
			child.animation_tree = animation_tree
			child.connect("interrupt_state", _on_interrupt_state)
		else:
			push_warning("Child " + child.name + " is not a State for CharacterStateMachine")
	if current_state:
		current_state.on_enter()
	animation_tree.active = true
	invincible_tween = get_tree().create_tween()
	
func _physics_process(delta: float) -> void:
	current_state.state_process(delta)
	
	if current_state.next_state != null:
		switch_state(current_state.next_state)
	if !current_state.can_move:
		character.velocity = Vector2.ZERO
		
	# 处理无敌
	if State.is_invincible:
		EventBus.emit_signal("on_monirable_changed", false)
		invincible_tween.tween_property($"../Sprite2D", "shader_parameter/flash_state", 1, 1)
		invincible_tween.tween_property($"../Sprite2D", "shader_parameter/flash_state", 0, 1)

	
		
func _input(event: InputEvent) -> void:
	current_state.state_input(event)
		
func switch_state(new_state : State):
	if current_state:
		current_state.on_exit()
		current_state.next_state = null
	current_state = new_state
	current_state.on_enter()
	
func _on_interrupt_state(new_state : State):
	switch_state(new_state)
	
func check_if_can_direction():
	if current_state:
		return current_state.can_direction
