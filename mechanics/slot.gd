class_name Slot
extends Node
## Dynamicly manages the specific mechanic ([class FSM]).

## Existing Slot colors
enum Colors {
NONE = 0, ## No color
BLUE = 1,
YELLOW = 2,
GREEN = 3
}
const ColorsToStr: Dictionary[Colors, StringName] = {
	Colors.NONE: &"None",
	Colors.BLUE: &"Blue",
	Colors.YELLOW: &"Yellow",
	Colors.GREEN: &"Green"
}

## Slot color
@export var color: Colors = Colors.NONE

## Currently loaded scene resource
@export var _loaded_fsm: PackedScene = DEFAULT_FSM
## Prevents multiple loads in single frame
var _loaded_this_frame: bool = false

const DEFAULT_FSM: PackedScene = preload("res://mechanics/noop.tscn") ## NoOp

func _ready() -> void:
	# If we already have child mechanic, don't initialize
	if get_child_count() != 0:
		return
	set_mechanic(null)

## Load mechanic ([class FSM]) if it's not loaded and hasn't been loaded in this frame before[br]
## Returns: [code]true[/code] on success
func set_mechanic(scene: PackedScene) -> bool:
	if _loaded_this_frame or _loaded_fsm == scene:
		return false
	for c in get_children():
		c.queue_free()
	var instance: FSM
	if not scene:
		scene = DEFAULT_FSM
	
	instance = scene.instantiate()
	_loaded_fsm = scene
	add_child(instance)
	_loaded_this_frame = true
	set_deferred("_loaded_this_frame", false)
	return true

func is_empty() -> bool:
	return _loaded_fsm == DEFAULT_FSM

## for modulation, idk
# const ColorsToColor: Dictionary[Colors, Color] = {
#     Colors.NONE: Color.GRAY,
#     Colors.BLUE: Color.BLUE,
#     Colors.YELLOW: Color.YELLOW,
#     Colors.GREEN: Color.GREEN
# }
