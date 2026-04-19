extends MovementStateSS

func enter() -> Variant:
	print("walk")
	return null

func physics_update(_delta: float) -> Variant:
	## Add the gravity.
	if not character.is_on_floor():
		character.velocity += (-1 * c_up) * character.get_gravity().length() * _delta
	elif Input.is_action_pressed(ACTION_JUMP):
		super (_delta) # Horizontal movement & box sliding
		return &"jump" # move_and_slide in jump.enter()

	super (_delta) # Horizontal movement & box sliding
	character.move_and_slide()
	return null
