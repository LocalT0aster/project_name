extends Node
class_name State

@warning_ignore("UNUSED_SIGNAL")
signal transition
#transition.emit("name_of_new_state")
func enter():
	pass
func exit():
	pass
func update(_delta : float) -> void:
	pass
func physics_update(_delta : float) -> void:
	pass
func unhandled_event(_event: InputEvent) -> void:
	pass
func event(_event: InputEvent) -> void:
	pass
