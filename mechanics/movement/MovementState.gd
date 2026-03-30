class_name MovementState
extends State

var parent: MovementFSM

func _ready() -> void:
	parent = get_parent() as MovementFSM
