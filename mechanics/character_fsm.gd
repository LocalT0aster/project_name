class_name CharacterFSM
extends FSM

@export var character: CharacterBody2D

func _ready() -> void:
	var _parent = get_parent()
	while (_parent != null and _parent != get_tree()):
		if _parent is CharacterBody2D:
			character = _parent as CharacterBody2D
			break
		_parent = _parent.get_parent()
	if character == null or _parent == null or _parent == get_tree():
		printerr("MovementFSM: unable to find ancestor CharacterBody2D")
	super ()
