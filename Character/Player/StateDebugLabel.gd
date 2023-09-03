extends Label

class_name StateDebugLabel

@export var state_machine : CharacterStateMachine

func _process(_delta: float) -> void:
	text = "State:" + state_machine.current_state.name
