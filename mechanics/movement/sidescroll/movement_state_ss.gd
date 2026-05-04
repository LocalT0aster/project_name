class_name MovementStateSS
extends CharacterState

## Bindings to MovementFSM because it stores the values,
## avoids writing 100 get_parent()

const ACTION_JUMP: StringName = MovementFSM.ACTION_JUMP
const ACTION_RIGHT: StringName = MovementFSM.ACTION_RIGHT
const ACTION_LEFT: StringName = MovementFSM.ACTION_LEFT
const ACTION_DOWN: StringName = MovementFSM.ACTION_DOWN
const ACTION_UP: StringName = MovementFSM.ACTION_UP

var speed: float:
	get: return get_parent().speed
	set(value):	get_parent().speed = value
var jump_velocity: float:
	get: return get_parent().jump_velocity
	set(value): get_parent().jump_velocity = value
var push_force: float:
	get: return get_parent().push_force
	set(value): get_parent().push_force = value

## Horizontal movement & box sliding
func physics_update(_delta: float) -> Variant:
	c_up = Vector2.UP.rotated(character.rotation)
	## Horizontal movement
	var direction: float = Input.get_axis(ACTION_LEFT, ACTION_RIGHT)
	
	if direction:
		character.sprite.scale.x = sign(direction) * abs(character.sprite.scale.x)
		## Zero movement to the character's local right
		character.velocity -= character.velocity.project(c_right)
		## Add movement to the character's local right
		character.velocity += direction * c_right * speed
	else:
		var h_velocity: Vector2 = character.velocity.project(c_right)
		var v_velocity: Vector2 = character.velocity.project(c_up)
		character.velocity = v_velocity + h_velocity.move_toward(Vector2.ZERO, speed)

	## Box sliding or something
	if character.slidin:
		for i in character.get_slide_collision_count():
			var c = character.get_slide_collision(i)
			if c.get_collider() is RigidBody2D:
				c.get_collider().apply_central_impulse(-c.get_normal() * push_force)

	## move_and_slide manually when needed
	return null
