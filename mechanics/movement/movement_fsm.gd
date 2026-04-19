class_name MovementFSM
extends CharacterFSM

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
