extends MovementStateSS

func physics_update(_delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction: float = Input.get_axis(get_parent().ACTION_LEFT, get_parent().ACTION_RIGHT)
	if direction:
		get_parent().character.velocity.x = direction * get_parent().speed
	else:
		get_parent().character.velocity.x = move_toward(get_parent().character.velocity.x, 0, get_parent().speed)

	if Input.is_action_pressed(get_parent().ACTION_JUMP) and get_parent().character.is_on_floor():
		transition.emit(self , "jump")

	# Add the gravity.
	if not get_parent().character.is_on_floor():
		get_parent().character.velocity += get_parent().character.get_gravity() * _delta

	get_parent().character.move_and_slide()
	super (_delta)
