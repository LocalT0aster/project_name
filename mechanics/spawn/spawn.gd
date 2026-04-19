extends SpawnFSMState

func enter() -> Variant:
	#var cursor = (character as Node2D).global_position
	var object = (prefab.instantiate() as Node2D)
	if at_cursor:
		object.global_position = character.get_global_mouse_position()
	else:
		object.global_position = character.global_position
		var dir: Vector2 = (character.get_global_mouse_position() - character.global_position).normalized()
		object.look_at(character.global_position + dir)
		object.position += dir * distance
	character.add_sibling(object)

	return &"idle"

func physics_update(_delta: float) -> Variant:
	return &"idle"
