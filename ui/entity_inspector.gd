class_name EntityInspector
extends Control
## Displays and edits the colored equipment slots for one entity.

## Scene used to instantiate colored equipment slots.
@export var entity_inspector_slot: PackedScene = preload("res://ui/item_slot.tscn")

## Instance ID of the inspected [MechanicsTree].
@export var entity_id: int = 0

## Requests that an inspector slot be ejected into inventory.
signal eject_slot(item: ItemSlot)

## Container that receives generated equipment [ItemSlot] nodes.
@export var slots_container: Control
## Container reserved for generated mechanic parameters.
@export var params_container: Control

var _color2slot: Dictionary[Slot.Colors, ItemSlot] = {}

## Removes generated slots and parameter controls.
func clear() -> void:
	for c in slots_container.get_children(): c.queue_free()
	for c in params_container.get_children(): c.queue_free()
	_color2slot.clear()

## Rebuilds equipment slots from the current [member entity_id].
func init_slots() -> void:
	clear()
	var entity: MechanicsTree = MechanicManager.entity_trees[entity_id]
	for color in Slot.Colors.values():
		if color == Slot.Colors.NONE or not entity.enabled_slots.get(color, false):
			continue
		entity.ensure_slot(color)
		var slot: ItemSlot = _create_item_slot(color)
		slot.item = _duplicate_representative_item(entity, color)
		slot.update_ui()

## Syncs visible slots from [MechanicsTree] and returns displaced items.
func update_slots() -> Array[ItemMechanic]:
	var displaced_items: Array[ItemMechanic] = []
	var entity: MechanicsTree = MechanicManager.entity_trees[entity_id]
	for color in Slot.Colors.values():
		if color == Slot.Colors.NONE:
			continue
		if not entity.enabled_slots.get(color, false):
			var removed_item: ItemMechanic = _remove_item_slot(color)
			if removed_item:
				displaced_items.append(removed_item)
			entity.remove_slot(color)
			continue

		entity.ensure_slot(color)
		var slot: ItemSlot = _color2slot.get(color) as ItemSlot
		if not slot:
			slot = _create_item_slot(color)

		var expected_item: ItemMechanic = _duplicate_representative_item(entity, color)
		if _items_match(slot.item, expected_item):
			if expected_item:
				slot.item = expected_item
			slot.update_ui()
			continue
		if slot.item:
			displaced_items.append(slot.item)
		slot.item = expected_item
		slot.update_ui()
	return displaced_items

func _create_item_slot(color: Slot.Colors) -> ItemSlot:
	var slot: ItemSlot = entity_inspector_slot.instantiate()
	slot.color = color
	slot.entity_id = entity_id
	slot.item_changed.connect(_on_item_changed.bind(color))
	slot.quick_transfer_requested.connect(_on_slot_quick_transfer_requested)
	_color2slot[color] = slot
	slots_container.add_child(slot)
	return slot

func _remove_item_slot(color: Slot.Colors) -> ItemMechanic:
	var slot: ItemSlot = _color2slot.get(color) as ItemSlot
	if not slot:
		return null
	_color2slot.erase(color)
	var removed_item: ItemMechanic = slot.item
	slot.item = null
	slot.update_ui()
	slot.queue_free()
	return removed_item

func _duplicate_representative_item(entity: MechanicsTree, color: Slot.Colors) -> ItemMechanic:
	if entity.is_slot_empty(color):
		return null
	var mechanic: FSM = entity.get_slot_mechanic(color)
	var card: ItemMechanic = mechanic.representative_item if mechanic else null
	if card:
		return card.duplicate() as ItemMechanic
	if mechanic:
		printerr("Mechanic %s has no representative ItemMechanic." % mechanic.name)
	else:
		printerr("Missing mechanic for slot %s." % Slot.ColorsToStr[color])
	return null

func _items_match(current_item: ItemMechanic, expected_item: ItemMechanic) -> bool:
	if current_item == null or expected_item == null:
		return current_item == expected_item
	return current_item.mechanic == expected_item.mechanic and current_item.color == expected_item.color

func _on_item_changed(item: ItemMechanic, color: Slot.Colors) -> void:
	if not MechanicManager.entity_trees.has(entity_id):
		return
	MechanicManager.entity_trees[entity_id].set_slot_mechanic(color, item.mechanic if item else null)

func _on_slot_quick_transfer_requested(slot: ItemSlot) -> void:
	eject_slot.emit(slot)

## Returns the compatible visible slot for [param item], or [code]null[/code].
func get_slot_for_item(item: ItemMechanic) -> ItemSlot:
	if not item:
		return null
	return _color2slot.get(item.color)

## Unequips every non-empty slot and returns the removed items.
func eject_all() -> Array[ItemMechanic]:
	var ejected_items: Array[ItemMechanic] = []
	var slots = slots_container.get_children()
	for s in slots:
		var slot: ItemSlot = s as ItemSlot
		if not slot or not slot.item:
			continue
		ejected_items.append(slot.replace_item(null))
	return ejected_items
