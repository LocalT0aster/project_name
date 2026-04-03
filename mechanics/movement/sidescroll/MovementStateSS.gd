class_name MovementStateSS
extends State

func physics_update(_delta: float) -> void:
	for i in get_parent().character.get_slide_collision_count():
		var c = get_parent().character.get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * get_parent().push_force)
