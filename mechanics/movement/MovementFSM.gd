class_name MovementFSM
extends FSM

@export var character: CharacterBody2D

const ACTION_JUMP: StringName = &"jump"
const ACTION_RIGHT: StringName = &"right"
const ACTION_LEFT: StringName = &"left"
const ACTION_DOWN: StringName = &"down"
const ACTION_UP: StringName = &"up"

@export var speed: float = 300.0
@export var jump_velocity: float = 400
@export var push_force: float = 80.0


func _ready():
	super ()
	var _parent = get_parent()
	while (_parent != null and _parent != get_tree()):
		if _parent is CharacterBody2D:
			character = _parent as CharacterBody2D
			break
		_parent = _parent.get_parent()
	if character == null or _parent == null or _parent == get_tree():
		printerr("MovementFSM: unable to find ancestor CharacterBody2D")
