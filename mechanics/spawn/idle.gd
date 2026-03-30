extends State

const SPAWN_ACTION: StringName = &"left_mouse_click"

func physics_update(_delta : float) -> void:
	if Input.is_action_just_pressed(SPAWN_ACTION):
		transition.emit(self, "spawn")
