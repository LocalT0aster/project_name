extends MovementStateSS

func enter():
	super()

func physics_update(_delta : float) -> void:
	if not parent.character:
		return
	if Input.is_action_just_pressed(parent.ACTION_JUMP) and parent.character.is_on_floor():
		print("jump")
		transition.emit(self, "jump")

	if Input.is_action_pressed(parent.ACTION_LEFT) or Input.is_action_just_pressed(parent.ACTION_RIGHT):
		print("walk")
		transition.emit(self, "walk")
	
	# Add the gravity.
	if not parent.character.is_on_floor():
		parent.character.velocity += parent.character.get_gravity() * _delta

	parent.character.move_and_slide()
	super(_delta)
