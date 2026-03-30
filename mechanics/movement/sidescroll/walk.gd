extends MovementStateSS

@export var speed = 300.0

func physics_update(_delta : float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction: float = Input.get_axis(parent.ACTION_LEFT, parent.ACTION_RIGHT)
	if direction:
		parent.character.velocity.x = direction * speed
	else:
		parent.character.velocity.x = move_toward(parent.character.velocity.x, 0, speed)

	if Input.is_action_pressed(parent.ACTION_JUMP) and parent.character.is_on_floor():
		transition.emit(self, "jump")

	# Add the gravity.
	if not parent.character.is_on_floor():
		parent.character.velocity += parent.character.get_gravity() * _delta

	parent.character.move_and_slide()
	super(_delta)
