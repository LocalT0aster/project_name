class_name SpawnFSM
extends CharacterFSM

@export var prefab: PackedScene
@export var distance: float = 32.0
@export var at_cursor: bool = false
const SPAWN_ACTION: StringName = &"left_mouse_click"

func _ready():
	super ()
