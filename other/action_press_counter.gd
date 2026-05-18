class_name ActionPressCounter
extends Node

## Counts just-pressed input actions and mirrors the total into Dialogic.
signal counter_changed(count: int, action: StringName)

## InputMap actions counted once when they become pressed.
@export var actions: Array[StringName] = [&"ui_accept"]

## Dialogic variable path that receives [member counter].
@export var dialogic_variable: String = "action_press_count"

## Total counted presses across all configured actions.
var counter: int = 0:
	set(value):
		if counter == value:
			return
		counter = value
		if _is_ready and not _syncing_from_dialogic:
			_publish_counter()

var _is_ready: bool = false
var _syncing_from_dialogic: bool = false


func _ready() -> void:
	_is_ready = true
	_connect_dialogic_variable_changed()
	_publish_counter()


func _process(_delta: float) -> void:
	var checked_actions: Array[StringName] = []
	for action: StringName in actions:
		if action.is_empty() or action in checked_actions:
			continue
		checked_actions.append(action)
		if not InputMap.has_action(action):
			continue
		if Input.is_action_just_pressed(action):
			counter += 1
			counter_changed.emit(counter, action)


## Sets the counter and syncs it to Dialogic.
func set_counter(value: int) -> void:
	counter = value


## Resets the counter to zero and syncs it to Dialogic.
func reset_counter() -> void:
	set_counter(0)


func _connect_dialogic_variable_changed() -> void:
	if not _has_dialogic_variable_api():
		return
	if Dialogic.VAR.variable_changed.is_connected(_on_dialogic_variable_changed):
		return
	Dialogic.VAR.variable_changed.connect(_on_dialogic_variable_changed)


func _on_dialogic_variable_changed(info: Dictionary) -> void:
	if info.get("variable", "") != dialogic_variable:
		return
	var new_value: Variant = info.get("new_value", counter)
	if not str(new_value).is_valid_int():
		return
	_syncing_from_dialogic = true
	counter = int(new_value)
	_syncing_from_dialogic = false


func _publish_counter() -> void:
	if not _has_dialogic_variable_api() or dialogic_variable.is_empty():
		return
	if not _ensure_dialogic_variable():
		push_warning("Could not register Dialogic variable '%s'." % dialogic_variable)
		return
	Dialogic.VAR.set_variable(dialogic_variable, counter)


func _has_dialogic_variable_api() -> bool:
	return is_inside_tree() and has_node("/root/Dialogic") and Dialogic.VAR != null


func _ensure_dialogic_variable() -> bool:
	if Dialogic.VAR.has(dialogic_variable):
		return true
	var keys := dialogic_variable.split(".")
	var folder: Dictionary = Dialogic.VAR.var_storage
	for key_index: int in range(keys.size()):
		var key := keys[key_index]
		if key.is_empty():
			return false
		var is_value_key := key_index == keys.size() - 1
		if is_value_key:
			folder[key] = counter
			return true
		if not folder.has(key) or not (folder[key] is Dictionary):
			folder[key] = {}
		folder = folder[key]
	return false
