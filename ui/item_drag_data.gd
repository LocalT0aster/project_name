class_name ItemDragData
extends RefCounted

var item: ItemMechanic = null
var source_slot_ref: WeakRef = null
var source_color: Slot.Colors = Slot.Colors.NONE
var source_entity_id: int = 0
var source_invalidated: bool = false

func _init(
		p_item: ItemMechanic = null,
		p_source_slot_ref: WeakRef = null,
		p_source_color: Slot.Colors = Slot.Colors.NONE,
		p_source_entity_id: int = 0
) -> void:
	item = p_item
	source_slot_ref = p_source_slot_ref
	source_color = p_source_color
	source_entity_id = p_source_entity_id

func is_from_inventory() -> bool:
	return source_color == Slot.Colors.NONE

func is_from_entity_slot() -> bool:
	return source_color != Slot.Colors.NONE

func get_source_slot() -> ItemSlot:
	if source_invalidated or not source_slot_ref:
		return null
	var source: Object = source_slot_ref.get_ref()
	return source as ItemSlot

func invalidate_source() -> void:
	source_invalidated = true
