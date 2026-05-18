extends CharacterState

func physics_update(_delta: float) -> Variant:
	c_up = Vector2.UP.rotated(character.rotation)
	if not character.is_on_floor():
		character.velocity += (-1 * c_up) * character.get_gravity().length() * _delta
	character.move_and_slide()
	return null
