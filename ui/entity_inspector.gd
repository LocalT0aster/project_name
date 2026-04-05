class_name EntityInspector
extends Control

## ItemSlot scene
@export var entity_inspector_slot: PackedScene = preload("res://ui/item_slot.tscn")

## Instace ID of the MechanicTree
@export var entity_id: int = 0

@export var slots_container: Control
@export var params_container: Control

var _color2slot: Dictionary[Slot.Colors, ItemSlot] = {}

func clear() -> void:
	for c in slots_container.get_children(): c.queue_free()
	for c in params_container.get_children(): c.queue_free()

func init_slots() -> void:
	clear()
	var entity: MechanicsTree = MechanicManager.entity_trees[entity_id]
	for color in Slot.Colors.keys():
		if not entity.enabled_slots[color as int]:
			continue
		var slot: ItemSlot = entity_inspector_slot.instantiate()
		slot.color = entity.get_slot(color).color
		slot.item_changed.connect(_on_item_changed.bind(color))
		_color2slot[color] = slot
		slots_container.add_child(slot)

func _on_item_changed(item: ItemMechanic, color: Slot.Colors) -> void:
	MechanicManager.entity_trees[entity_id].set_slot_mechanic(color, item.mechanic)

func eject_all() -> void:
	push_warning("NotImplemented: eject_all %d" % entity_id)
	# TODO eject logic
