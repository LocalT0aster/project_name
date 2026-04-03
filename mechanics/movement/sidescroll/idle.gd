extends MovementStateSS

func enter():
	super ()

func physics_update(_delta: float) -> void:
	if not get_parent().character:
		return
	if Input.is_action_just_pressed(get_parent().ACTION_JUMP) and get_parent().character.is_on_floor():
		print("jump")
		transition.emit(self , "jump")

	if Input.is_action_pressed(get_parent().ACTION_LEFT) or Input.is_action_just_pressed(get_parent().ACTION_RIGHT):
		print("walk")
		transition.emit(self , "walk")
	
	# Add the gravity.
	if not get_parent().character.is_on_floor():
		get_parent().character.velocity += get_parent().character.get_gravity() * _delta

	get_parent().character.move_and_slide()
	super (_delta)
