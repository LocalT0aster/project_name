class_name MechanicsTree
extends Node
## Dynamicly manages [class Slot]s for entity (parent) mechanics ([class FSM]).

## Entity (parent) name property
var e_name: StringName:
	get:
		return get_parent().name
	set(value):
		get_parent().name = value
		MechanicManager.entity_update.emit(get_instance_id())

## Enabled [enum Slot.Colors], starting from [constant Slot.Colors.NONE]
@export var enabled_slots: Dictionary[Slot.Colors, bool] = {
	Slot.Colors.NONE: false,
	Slot.Colors.BLUE: false,
	Slot.Colors.YELLOW: false,
	Slot.Colors.GREEN: false
}
## Slot by color dict
var slots: Dictionary[Slot.Colors, Slot] = {}

func _ready() -> void:
	print(e_name + " ready")

func init() -> void:
	## If we have no children, create empty slots from enabled_slots
	if get_child_count() == 0:
		for c in enabled_slots.keys():
			if not enabled_slots[c]:
				continue
			_create_slot(c)
	else: ## We have predefined slots, use them
		for child in get_children():
			assert(child is Slot, "MechanicTree must contain Slots.")
			## add to [member enabled_slots] if enabled and is not a duplicate color
			if enabled_slots[child.color] and not slots.has(child.color):
				slots[child.color] = child
			else: ## destroy otherwise
				child.queue_free()
		for color in Slot.Colors.values(): ## If we're still missing some slots of certain color, create them
			if enabled_slots[color] and not slots.has(color):
				_create_slot(color)
		# MechanicManager.entity_update.emit(get_instance_id())
	print(e_name + " init")

func _create_slot(c: Slot.Colors) -> Slot:
	var s: Slot = Slot.new()
	s.color = c
	s.name = "Slot" + Slot.ColorsToStr[c]
	slots[c] = s
	add_child(s)
	return s

## Creates and returns the backend [Slot] for [param color] when it is enabled.
func ensure_slot(color: Slot.Colors) -> Slot:
	if not enabled_slots.get(color, false):
		return null
	var slot: Slot = slots.get(color) as Slot
	if slot and is_instance_valid(slot) and not slot.is_queued_for_deletion():
		return slot
	slots.erase(color)
	return _create_slot(color)

## Stops and removes the backend [Slot] for [param color].
func remove_slot(color: Slot.Colors) -> void:
	var slot: Slot = slots.get(color) as Slot
	if not slot:
		return
	slots.erase(color)
	if is_instance_valid(slot) and not slot.is_queued_for_deletion():
		slot.process_mode = Node.PROCESS_MODE_DISABLED
		slot.queue_free()

## Get [class Slot] by color
func get_slot(color: Slot.Colors) -> Slot:
	return slots[color] if enabled_slots[color] else null

## Get [class FSM] by color
func get_slot_mechanic(color: Slot.Colors) -> FSM:
	return slots[color].get_child(0) if enabled_slots[color] else null

## Returns: [code]true[/code] when [Slot] is enabled and [method Slot.is_empty].
func is_slot_empty(color: Slot.Colors) -> bool:
	return slots[color].is_empty() if enabled_slots[color] else true

## Returns: [code]true[/code] when at least 1 [Slot] is not [method Slot.is_empty].
func has_non_empty_slots() -> bool:
	var all_empty = true
	for c in Slot.Colors.values():
		all_empty = all_empty and is_slot_empty(c)
	return not all_empty


## Set [class FSM] (scene) by color[br]
## Returns: [code]true[/code] on success
func set_slot_mechanic(color: Slot.Colors, scene: PackedScene) -> bool:
	if enabled_slots[color] and slots.get(color):
		return slots[color].set_mechanic(scene)
	else:
		printerr("Tried to set mechanic to disabled slot.")
		return false
