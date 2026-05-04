class_name MechanicPanel
extends Control
## Coordinates entity inspectors, inventory slots, and item drag cleanup.

## Scene used for entity selection buttons.
@export var entity_button: PackedScene = preload("res://ui/entity_button.tscn")
## Scene used for per-entity equipment inspectors.
@export var entity_inspector: PackedScene = preload("res://ui/entity_inspector.tscn")

## Container holding [EntityButton] instances.
@export var entities_container: Control
## Container holding [EntityInspector] instances.
@export var inspectors_container: Control
## Container holding inventory [ItemSlot] instances.
@export var inventory_container: Control

## Message shown when the player exits the tree.
@export var death_msg: Label

var _id2button: Dictionary[int, EntityButton] = {}
var _id2inspector: Dictionary[int, EntityInspector] = {}
var _active_entity_id: int = 0
## Active [ItemDragData], or [code]null[/code] when no item card is held.
var drag_data = null

const _MECHANIC_TREE_PATH: NodePath = ^"./MechanicsTree"
const _empty_item_slot: PackedScene = preload("res://ui/item_slot.tscn")
const ItemDragDataScript: GDScript = preload("res://ui/item_drag_data.gd")
const SCRIPT_ID: StringName = &"MechanicPanel"

func _ready() -> void:
	# init()
	print("MechanicPanel ready")

func init() -> void:
	# Free containers from predefined children (mock ui entries)
	for c in entities_container.get_children(): c.queue_free()
	for c in inspectors_container.get_children(): c.queue_free()
	
	Util.connect_only(MechanicManager.entity_removed, _on_entity_remove)
	Util.connect_only(MechanicManager.entity_update, _on_entity_update)
	_connect_inventory_slots()

	# Instantiate new entity entries
	for id in MechanicManager.entity_trees.keys():
		_init_entity_button(id)
		_init_entity_inspector(id)
	if %player:
		var player_entity_id: int = %player.get_node(_MECHANIC_TREE_PATH).get_instance_id()
		_id2button[player_entity_id].button_pressed = true
		on_button_toggle(true, player_entity_id)
		if not %player.tree_exited.is_connected(_on_player_dead):
			%player.tree_exited.connect(_on_player_dead)

# Initializes the selector button for [param id].
func _init_entity_button(id: int) -> EntityButton:
	var btn: EntityButton = entity_button.instantiate()
	btn.text = MechanicManager.entity_trees[id].e_name
	btn.name = MechanicManager.entity_trees[id].e_name
	btn.toggled.connect(on_button_toggle.bind(id))
	btn.entity_id = id
	btn.drag_data_ref = weakref(self)
	_id2button[id] = btn
	entities_container.add_child(btn)
	return btn

# Initializes the equipment inspector for [param id].
func _init_entity_inspector(id: int) -> EntityInspector:
	var ins: EntityInspector = entity_inspector.instantiate()
	ins.name = MechanicManager.entity_trees[id].e_name
	ins.entity_id = id
	ins.init_slots()
	ins.eject_slot.connect(_on_inspector_quick_transfer)
	_id2inspector[id] = ins
	ins.visible = false
	inspectors_container.add_child(ins)
	return ins
	

## Shows the inspector for [param entity_id] when its button is toggled on.
func on_button_toggle(togled_on: bool, entity_id: int):
	for i in inspectors_container.get_children():
		i.hide()
	if !togled_on: return
	for btn in entities_container.get_children():
		if btn.entity_id == entity_id: continue
		btn.button_pressed = false
	_active_entity_id = entity_id
	_id2inspector[entity_id].show()


func _notification(what: int) -> void:
	match what:
		Node.NOTIFICATION_DRAG_BEGIN:
			drag_data = get_viewport().gui_get_drag_data()
			if not _is_item_drag_data(drag_data):
				drag_data = null
		Node.NOTIFICATION_DRAG_END:
			if drag_data:
				_finish_drag(drag_data)
				drag_data = null
		Node.NOTIFICATION_SCENE_INSTANTIATED:
			print("MechanicPanel NOTIFICATION_SCENE_INSTANTIATED")
		Node.NOTIFICATION_POST_ENTER_TREE:
			print("MechanicPanel NOTIFICATION_POST_ENTER_TREE")

func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	return false

func _on_entity_remove(id: int) -> void:
	if drag_data and drag_data.source_entity_id == id:
		drag_data.invalidate_source()

	_id2button[id].queue_free()
	_id2button.erase(id)

	for item in _id2inspector[id].eject_all():
		deposit_to_inventory(item)
	_id2inspector[id].queue_free()
	_id2inspector.erase(id)
	if _active_entity_id == id:
		_active_entity_id = 0

func _on_entity_update(id: int) -> void:
	var btn: EntityButton = _id2button.get(id)
	var ins: EntityInspector = _id2inspector.get(id)
	if btn:
		btn.text = MechanicManager.entity_trees[id].e_name
		btn.name = MechanicManager.entity_trees[id].e_name
	else:
		_init_entity_button(id)
	if ins:
		ins.name = MechanicManager.entity_trees[id].e_name
		

func _on_player_dead() -> void:
	death_msg.show()

## Returns whether an item card is currently being dragged.
func has_active_drag() -> bool:
	return drag_data != null and drag_data.item != null

## Places [param item] into inventory, creating a new slot if needed.
func deposit_to_inventory(item: ItemMechanic) -> ItemSlot:
	if not item:
		return null
	for child in inventory_container.get_children():
		var inventory_slot: ItemSlot = child as ItemSlot
		if inventory_slot and not inventory_slot.item and inventory_slot.can_accept_item(item):
			inventory_slot.replace_item(item)
			return inventory_slot
	var new_slot: ItemSlot = _empty_item_slot.instantiate()
	inventory_container.add_child(new_slot)
	_connect_inventory_slot(new_slot)
	new_slot.replace_item(item)
	return new_slot

## Returns the currently visible [EntityInspector], or [code]null[/code].
func get_active_inspector() -> EntityInspector:
	return _id2inspector.get(_active_entity_id)

func _connect_inventory_slots() -> void:
	for child in inventory_container.get_children():
		var slot: ItemSlot = child as ItemSlot
		if slot:
			_connect_inventory_slot(slot)

func _connect_inventory_slot(slot: ItemSlot) -> void:
	slot.color = Slot.Colors.NONE
	slot.entity_id = 0
	if not slot.quick_transfer_requested.is_connected(_on_inventory_quick_transfer):
		slot.quick_transfer_requested.connect(_on_inventory_quick_transfer)

func _finish_drag(data) -> void:
	if not data.item:
		return
	var source: ItemSlot = data.get_source_slot()
	if source and not source.item and source.can_accept_item(data.item):
		source.replace_item(data.item)
	else:
		deposit_to_inventory(data.item)
	data.item = null

func _on_inventory_quick_transfer(slot: ItemSlot) -> void:
	if not slot.item:
		return
	var inspector: EntityInspector = get_active_inspector()
	if not inspector:
		return
	var target: ItemSlot = inspector.get_slot_for_item(slot.item)
	if not target or not target.can_accept_item(slot.item):
		return
	var item_to_equip: ItemMechanic = slot.item
	var displaced: ItemMechanic = target.replace_item(item_to_equip)
	slot.replace_item(displaced)

func _on_inspector_quick_transfer(slot: ItemSlot) -> void:
	if not slot.item:
		return
	var ejected: ItemMechanic = slot.replace_item(null)
	deposit_to_inventory(ejected)

func _is_item_drag_data(data: Variant) -> bool:
	return data is RefCounted and data.get_script() == ItemDragDataScript
