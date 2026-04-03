extends State

func enter():
	var character = (get_parent() as SpawnFSM).character
	#var cursor = (character as Node2D).global_position
	var object = (get_parent().prefab.instantiate() as Node2D)
	if (get_parent() as SpawnFSM).at_cursor:
		object.global_position = character.get_global_mouse_position()
	else:
		object.global_position = character.global_position
		var dir: Vector2 = (character.get_global_mouse_position() - character.global_position).normalized()
		object.look_at(character.global_position + dir)
		object.position += dir * get_parent().distance
	character.add_sibling(object)

	transition.emit(self , "idle")

func physics_update(_delta: float) -> void:
	transition.emit(self , "idle")
