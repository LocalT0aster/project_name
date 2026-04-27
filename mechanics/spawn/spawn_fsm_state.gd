class_name SpawnFSMState
extends CharacterState

## Bindings to SpawnFSM because it stores the values,
## avoids writing 100 get_parent()

var prefab: PackedScene:
	get: return get_parent().prefab
	set (value): get_parent().prefab = value
var distance: float:
	get: return get_parent().distance
	set (value): get_parent().distance = value
var at_cursor: bool:
	get: return get_parent().at_cursor
	set (value): get_parent().at_cursor = value
const SPAWN_ACTION: StringName = SpawnFSM.SPAWN_ACTION
