class_name EntityInspector
extends Control

## ItemSlot scene
@export var entity_inspector_slot: PackedScene = preload("res://ui/item_slot.tscn")

## Instace ID of the MechanicTree
@export var entity_id: int = 0
## WeakRef to the [member MechanicsPanel.inventory_container]
var inventory_ref: WeakRef = null

signal eject_slot(item: ItemSlot)

@export var slots_container: Control
@export var params_container: Control

var _color2slot: Dictionary[Slot.Colors, ItemSlot] = {}
const _empty_item_slot: PackedScene = preload("res://ui/item_slot.tscn")

func clear() -> void:
	for c in slots_container.get_children(): c.queue_free()
	for c in params_container.get_children(): c.queue_free()

func init_slots() -> void:
	clear()
	var entity: MechanicsTree = MechanicManager.entity_trees[entity_id]
	for color in Slot.Colors.values():
		if not entity.enabled_slots[color]:
			continue
		var slot: ItemSlot = entity_inspector_slot.instantiate()
		slot.color = color
		if not entity.is_slot_empty(color):
			var card: ItemMechanic = entity.get_slot_mechanic(color).representative_item
			if card:
				slot.item = card.duplicate() as ItemMechanic
			else:
				printerr("Mechanic %s has no representative ItemMechanic." % entity.get_slot_mechanic(color).name)
		slot.item_changed.connect(_on_item_changed.bind(color))
		_color2slot[color] = slot
		slots_container.add_child(slot)


func _on_item_changed(item: ItemMechanic, color: Slot.Colors) -> void:
	MechanicManager.entity_trees[entity_id].set_slot_mechanic(color, item.mechanic if item else null)

func _eject_handler(slot: ItemSlot) -> void:
	assert(slot.color != Slot.Colors.NONE, "Inspector slots must have color")
	if not inventory_ref or not inventory_ref.get_ref():
		printerr("No link to the inventory, unable to eject cards for EntityTree %d" % entity_id)
		return
	for c in inventory_ref.get_ref().get_children():
		if c.item != null:
			continue
		slot.swap_item_with(c)
		return
	## No inventory space, crete new slot
	var c = _empty_item_slot.instantiate()
	inventory_ref.get_ref().add_child(c)
	slot.swap_item_with(c)

func _insert_handler(slot: ItemSlot) -> void:
	pass

func eject_all() -> void:
	if not inventory_ref or not inventory_ref.get_ref():
		printerr("No link to the inventory, destroying cards for EntityTree %d" % entity_id)
		return
	var inventory = inventory_ref.get_ref().get_children()
	var slots = slots_container.get_children()
	var index = 0
	var successfull_swap = false
	for s in slots:
		while index < slots.size():
			if inventory[index].item != null:
				index += 1
				continue
			s.swap_item_with(inventory[index])
			index += 1
			successfull_swap = true
			break
		if successfull_swap:
			successfull_swap = false
			continue
		## No inventory space, crete new slot
		var c = _empty_item_slot.instantiate()
		inventory_ref.get_ref().add_child(c)
		s.swap_item_with(c)
		index += 1
