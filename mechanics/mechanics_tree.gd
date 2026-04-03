class_name MechanicsTree
extends Node

var e_name: StringName:
	get:
		return get_parent().name
	set(value):
		get_parent().name = value
@export var enabled_slots: Array[bool] = [false, false, false, false]
var slots: Dictionary[Slot.Colors, Slot] = {}

func _ready() -> void:
	# MechanicManager.entity_trees[get_instance_id()] = self
	if get_child_count() == 0:
		for i in range(1, Slot.Colors.size()):
			if not enabled_slots[i]:
				continue
			var s = Slot.new()
			s.color = i
			slots[i] = s
			add_child(s)
	else:
		for c in get_children():
			assert(c is Slot, "MechanicTree must contain Slots.")
			if enabled_slots[c.color] and not slots.has(c.color): # if enabled and is not a duplicate color
				slots[c.color] = c
			else:
				c.queue_free()


func get_slot(color: Slot.Colors) -> Slot:
	return slots[color] if enabled_slots[color] else null


func get_slot_mechanic(color: Slot.Colors) -> FSM:
	return slots[color].get_child(0) if enabled_slots[color] else null


func set_slot_mechanic(color: Slot.Colors, scene: PackedScene) -> bool:
	if enabled_slots[color]:
		return slots[color].set_mechanic(scene)
	else:
		printerr("Tried to set mechanic to disabled slot.")
		return false
