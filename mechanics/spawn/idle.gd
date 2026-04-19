extends SpawnFSMState

func unhandled_event(_event: InputEvent) -> Variant:
	if Input.is_action_just_pressed(SPAWN_ACTION):
		return &"spawn"
	return null
