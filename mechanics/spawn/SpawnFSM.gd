class_name SpawnFSM
extends FSM

@export var character: CharacterBody2D
@export var at_cursor: bool = false

func _ready():
	super()
	var _parent = get_parent()
	while(_parent != null and _parent != get_tree()):
		if _parent is CharacterBody2D:
			character = _parent as CharacterBody2D
			break
		_parent = _parent.get_parent()
	if character == null or _parent == null or _parent == get_tree():
		printerr("SpawnFSM: unable to find ancestor CharacterBody2D")
