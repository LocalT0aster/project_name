class_name MovementStateSS
extends MovementState

func physics_update(_delta : float) -> void:
	for i in parent.character.get_slide_collision_count():
		var c = parent.character.get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * parent.push_force)
