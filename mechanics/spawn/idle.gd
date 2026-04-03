extends State

func unhandled_event(_event: InputEvent) -> void:
	if Input.is_action_just_pressed(get_parent().SPAWN_ACTION):
		transition.emit(self , "spawn")

#func physics_update(_delta : float) -> void:
	#if Input.is_action_just_pressed(SPAWN_ACTION):
		#transition.emit(self, "spawn")
