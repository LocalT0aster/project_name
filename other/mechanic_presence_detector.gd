## Autoloaded detector that mirrors a configured mechanic presence check to Dialogic.
extends Node

## Emitted when the active source's target mechanic match changes.
signal presence_changed(is_present: bool, match_count: int, matched_slot_color: int)

## Fallback Dialogic variable prefix used when no source overrides it.
@export var default_dialogic_variable_prefix: String = "target_mechanic"

## True when the target FSM is equipped in at least one checked slot.
var is_present: bool = false

## Number of checked slots currently using the target FSM.
var match_count: int = 0

## First matching [enum Slot.Colors] value, or [constant Slot.Colors.NONE].
var matched_slot_color: int = Slot.Colors.NONE

## First matching slot color name, or [code]"None"[/code].
var matched_slot_name: StringName = Slot.ColorsToStr[Slot.Colors.NONE]

var _active_source: Node = null
var _is_ready: bool = false
var _trigger_timeline: StringName = &""
var _queued_timeline: StringName = &""
var _timeline_start_queued: bool = false


func _ready() -> void:
	_is_ready = true
	_refresh(true)


func _process(_delta: float) -> void:
	_refresh()
	_try_complete_timeline_trigger()


## Makes a scene-level source provide the current mechanic check settings.
func register_source(source: Node) -> void:
	if source == null:
		return
	_active_source = source
	_refresh(true)


## Clears the active source when it leaves the scene tree.
func unregister_source(source: Node) -> void:
	if _active_source == source:
		_apply_state(false, 0, Slot.Colors.NONE, true)
		_active_source = null


## Starts [param next_timeline] once the configured mechanic is present.
func arm_timeline_when_present(next_timeline: String) -> void:
	_trigger_timeline = StringName(next_timeline)
	var source: Node = _get_active_source()
	if source:
		source.set("enabled", true)
	_refresh(true)
	_try_complete_timeline_trigger()


## Cancels the pending mechanic-presence timeline trigger.
func cancel_timeline_trigger() -> void:
	_trigger_timeline = &""
	_clear_queued_timeline_start()


func _refresh(force_publish: bool = false) -> void:
	var source: Node = _get_active_source()
	if source == null or not bool(source.get("enabled")):
		_apply_state(false, 0, Slot.Colors.NONE, force_publish)
		return

	var target: PackedScene = source.get("target_mechanic") as PackedScene
	var tree: MechanicsTree = _get_source_tree(source)
	if target == null or tree == null:
		_apply_state(false, 0, Slot.Colors.NONE, force_publish)
		return

	var count: int = 0
	var first_color: int = Slot.Colors.NONE
	for color: int in _get_colors_to_scan(source):
		if color == Slot.Colors.NONE:
			continue
		if not bool(tree.enabled_slots.get(color, false)):
			continue
		var slot: Slot = tree.slots.get(color) as Slot
		if slot == null or not is_instance_valid(slot) or slot.is_queued_for_deletion():
			continue
		if _scenes_match(slot._loaded_fsm, target):
			count += 1
			if first_color == Slot.Colors.NONE:
				first_color = color

	_apply_state(count > 0, count, first_color, force_publish)


func _apply_state(new_is_present: bool, new_count: int, new_color: int, force_publish: bool = false) -> void:
	var changed: bool = (
		is_present != new_is_present
		or match_count != new_count
		or matched_slot_color != new_color
	)
	if not changed and not force_publish:
		return

	is_present = new_is_present
	match_count = new_count
	matched_slot_color = new_color
	matched_slot_name = StringName(Slot.ColorsToStr.get(new_color, &"None"))

	if _is_ready:
		_publish_state()
	presence_changed.emit(is_present, match_count, matched_slot_color)


func _get_active_source() -> Node:
	if _active_source == null:
		return null
	if not is_instance_valid(_active_source):
		_active_source = null
	return _active_source


func _get_source_tree(source: Node) -> MechanicsTree:
	var tree_path: Variant = source.get("mechanics_tree_path")
	if not (tree_path is NodePath) or String(tree_path).is_empty():
		return null
	return source.get_node_or_null(tree_path) as MechanicsTree


func _get_colors_to_scan(source: Node) -> Array[int]:
	var requested_color: int = int(source.get("slot_color"))
	var result: Array[int] = []
	if requested_color != Slot.Colors.NONE:
		result.append(requested_color)
		return result

	for color: int in Slot.Colors.values():
		if color != Slot.Colors.NONE:
			result.append(color)
	return result


func _scenes_match(current: PackedScene, target: PackedScene) -> bool:
	if current == null or target == null:
		return false
	var current_path: String = current.resource_path
	var target_path: String = target.resource_path
	if not current_path.is_empty() and not target_path.is_empty():
		return current_path == target_path
	return current == target


func _try_complete_timeline_trigger() -> void:
	if _trigger_timeline.is_empty() or not is_present:
		return
	var timeline: StringName = _trigger_timeline
	cancel_timeline_trigger()
	_queue_timeline_start(timeline)


func _queue_timeline_start(timeline: StringName) -> void:
	if timeline.is_empty():
		return
	_queued_timeline = timeline
	if _timeline_start_queued:
		return
	_timeline_start_queued = true
	if _has_dialogic_handler() and Dialogic.current_timeline != null:
		if not Dialogic.timeline_ended.is_connected(_on_dialogic_timeline_ended):
			Dialogic.timeline_ended.connect(_on_dialogic_timeline_ended, CONNECT_ONE_SHOT)
		return
	call_deferred("_start_queued_timeline")


func _clear_queued_timeline_start() -> void:
	_queued_timeline = &""
	_timeline_start_queued = false
	if _has_dialogic_handler() and Dialogic.timeline_ended.is_connected(_on_dialogic_timeline_ended):
		Dialogic.timeline_ended.disconnect(_on_dialogic_timeline_ended)


func _on_dialogic_timeline_ended() -> void:
	call_deferred("_start_queued_timeline")


func _start_queued_timeline() -> void:
	if not _timeline_start_queued:
		return
	if not _has_dialogic_handler():
		_timeline_start_queued = false
		_queued_timeline = &""
		return
	if Dialogic.current_timeline != null:
		if not Dialogic.timeline_ended.is_connected(_on_dialogic_timeline_ended):
			Dialogic.timeline_ended.connect(_on_dialogic_timeline_ended, CONNECT_ONE_SHOT)
		return

	var timeline: StringName = _queued_timeline
	_timeline_start_queued = false
	_queued_timeline = &""
	if not timeline.is_empty():
		Dialogic.start(timeline)


func _publish_state() -> void:
	if not _has_dialogic_variable_api():
		return

	var prefix: String = _get_dialogic_variable_prefix()
	if prefix.is_empty():
		return

	_publish_dialogic_value("%s_present" % prefix, is_present)
	_publish_dialogic_value("%s_count" % prefix, match_count)
	_publish_dialogic_value("%s_slot_color" % prefix, matched_slot_color)
	_publish_dialogic_value("%s_slot_name" % prefix, String(matched_slot_name))


func _get_dialogic_variable_prefix() -> String:
	var source: Node = _get_active_source()
	if source == null:
		return default_dialogic_variable_prefix

	var source_prefix: Variant = source.get("dialogic_variable_prefix")
	if source_prefix is String:
		return source_prefix
	return default_dialogic_variable_prefix


func _publish_dialogic_value(variable_name: String, value: Variant) -> void:
	if variable_name.is_empty():
		return
	if not _ensure_dialogic_variable(variable_name, value):
		push_warning("Could not register Dialogic variable '%s'." % variable_name)
		return
	Dialogic.VAR.set_variable(variable_name, value)


func _has_dialogic_variable_api() -> bool:
	return is_inside_tree() and has_node("/root/Dialogic") and Dialogic.VAR != null


func _has_dialogic_handler() -> bool:
	return is_inside_tree() and has_node("/root/Dialogic")


func _ensure_dialogic_variable(variable_name: String, default_value: Variant) -> bool:
	if Dialogic.VAR.has(variable_name):
		return true
	var keys := variable_name.split(".")
	var folder: Dictionary = Dialogic.VAR.var_storage
	for key_index: int in range(keys.size()):
		var key := keys[key_index]
		if key.is_empty():
			return false
		var is_value_key := key_index == keys.size() - 1
		if is_value_key:
			folder[key] = default_value
			return true
		if not folder.has(key) or not (folder[key] is Dictionary):
			folder[key] = {}
		folder = folder[key]
	return false
