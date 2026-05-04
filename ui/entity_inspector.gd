class_name EntityInspector
extends Control

## ItemSlot scene
@export var entity_inspector_slot: PackedScene = preload("res://ui/item_slot.tscn")

## Instace ID of the MechanicTree
@export var entity_id: int = 0

signal eject_slot(item: ItemSlot)

@export var slots_container: Control
@export var params_container: Control

var _color2slot: Dictionary[Slot.Colors, ItemSlot] = {}

func clear() -> void:
	for c in slots_container.get_children(): c.queue_free()
	for c in params_container.get_children(): c.queue_free()
	_color2slot.clear()

func init_slots() -> void:
	clear()
	var entity: MechanicsTree = MechanicManager.entity_trees[entity_id]
	for color in Slot.Colors.values():
		if not entity.enabled_slots[color]:
			continue
		var slot: ItemSlot = entity_inspector_slot.instantiate()
		slot.color = color
		slot.entity_id = entity_id
		if not entity.is_slot_empty(color):
			var card: ItemMechanic = entity.get_slot_mechanic(color).representative_item
			if card:
				slot.item = card.duplicate() as ItemMechanic
			else:
				printerr("Mechanic %s has no representative ItemMechanic." % entity.get_slot_mechanic(color).name)
		slot.item_changed.connect(_on_item_changed.bind(color))
		slot.quick_transfer_requested.connect(_on_slot_quick_transfer_requested)
		_color2slot[color] = slot
		slots_container.add_child(slot)


func _on_item_changed(item: ItemMechanic, color: Slot.Colors) -> void:
	MechanicManager.entity_trees[entity_id].set_slot_mechanic(color, item.mechanic if item else null)

func _on_slot_quick_transfer_requested(slot: ItemSlot) -> void:
	eject_slot.emit(slot)

func get_slot_for_item(item: ItemMechanic) -> ItemSlot:
	if not item:
		return null
	return _color2slot.get(item.color)

func eject_all() -> Array[ItemMechanic]:
	var ejected_items: Array[ItemMechanic] = []
	var slots = slots_container.get_children()
	for s in slots:
		var slot: ItemSlot = s as ItemSlot
		if not slot or not slot.item:
			continue
		ejected_items.append(slot.replace_item(null))
	return ejected_items
