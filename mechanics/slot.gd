class_name Slot
extends Node

enum Colors {
NONE = 0,
BLUE = 1,
YELLOW = 2,
GREEN = 3
}

@export var color: Colors = Colors.NONE

@export var _loaded_fsm: PackedScene = DEFAULT_FSM
var _loaded_this_frame: bool = false

const DEFAULT_FSM: PackedScene = preload("res://mechanics/noop.tscn")

func _ready() -> void:
	if get_child_count() != 0:
		return
	set_mechanic(_loaded_fsm)

func set_mechanic(scene: PackedScene) -> bool:
	if _loaded_this_frame or _loaded_fsm == scene:
		return false
	
	var instance: FSM
	if not scene:
		scene = DEFAULT_FSM
	
	instance = scene.instantiate()
	_loaded_fsm = scene
	add_child(instance)
	_loaded_this_frame = true
	set_deferred("_loaded_this_frame", false)
	return true

# const ColorsToColor: Dictionary[Colors, Color] = {
#     Colors.NONE: Color.GRAY,
#     Colors.BLUE: Color.BLUE,
#     Colors.YELLOW: Color.YELLOW,
#     Colors.GREEN: Color.GREEN
# }
