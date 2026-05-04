class_name ItemDragData
extends RefCounted
## Carries an [ItemMechanic] through a GUI drag transaction.
##
## Keeps the source [ItemSlot] weakly referenced so drag cleanup can survive
## an inspector slot being freed while the card is still held.

## Item currently held by this drag. Set to [code]null[/code] once committed.
var item: ItemMechanic = null
## Weak reference to the source [ItemSlot].
var source_slot_ref: WeakRef = null
## Source slot color; [constant Slot.Colors.NONE] means inventory.
var source_color: Slot.Colors = Slot.Colors.NONE
## Entity instance ID for drags that started from an [EntityInspector].
var source_entity_id: int = 0
## Whether the source slot was invalidated before the drag ended.
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

## Returns [code]true[/code] when the drag started from an inventory slot.
func is_from_inventory() -> bool:
	return source_color == Slot.Colors.NONE

## Returns [code]true[/code] when the drag started from an entity slot.
func is_from_entity_slot() -> bool:
	return source_color != Slot.Colors.NONE

## Returns the live source [ItemSlot], or [code]null[/code] when it is gone.
func get_source_slot() -> ItemSlot:
	if source_invalidated or not source_slot_ref:
		return null
	return source_slot_ref.get_ref() as ItemSlot

## Marks the source slot unusable without cancelling the active drag.
func invalidate_source() -> void:
	source_invalidated = true
