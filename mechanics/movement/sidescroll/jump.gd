extends MovementStateSS

func enter():
	#print("jump")
	character.velocity -= character.velocity.project(c_up)
	character.velocity += jump_velocity * c_up
	character.slidin = character.move_and_slide()
	return &"walk"

func physics_update(_delta: float) -> Variant:
	super (_delta) # Horizontal movement & box sliding
	character.slidin = character.move_and_slide()
	return &"walk"
