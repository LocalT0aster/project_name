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
			var s = Slot.new()
			s.color = c
			s.name = "Slot" + Slot.ColorsToStr[c]
			slots[c] = s
			add_child(s)
	else: ## We have predefined slots, use them
		for c in get_children():
			assert(c is Slot, "MechanicTree must contain Slots.")
			## add to [member enabled_slots] if enabled and is not a duplicate color
			if enabled_slots[c.color] and not slots.has(c.color):
				slots[c.color] = c
			else: # destroy otherwise
				c.queue_free()
		# MechanicManager.entity_update.emit(get_instance_id())
	print(e_name + " init")

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
