class_name ItemSlot
extends TextureRect

@onready var icon: TextureRect = $Icon
@export var item: ItemMechanic = null
@export var color: Slot.Colors = Slot.Colors.NONE
@export var disabled: bool = false
@export var entity_id: int = 0

signal item_changed(item: ItemMechanic)
signal quick_transfer_requested(slot: ItemSlot)

const ItemDragDataScript: GDScript = preload("res://ui/item_drag_data.gd")

var color_texture: Dictionary[Slot.Colors, Texture2D] = {
	Slot.Colors.NONE: preload("res://img/itemslot.png"),
	Slot.Colors.BLUE: preload("res://img/blueMechanicSlot.png"),
	Slot.Colors.YELLOW: preload("res://img/yellowMechanicSlot.png"),
	Slot.Colors.GREEN: preload("res://img/greenMechanicSlot.png")
}

func _ready() -> void:
	texture = color_texture[color]
	if icon:
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
	update_ui()

func update_ui() -> void:
	if item == null:
		if icon:
			icon.texture = null
			icon.hide()
		tooltip_text = ""
		return
	if icon:
		icon.show()
		icon.texture = item.sprite
	tooltip_text = item.mechanic_name

func can_accept_item(new_item: ItemMechanic) -> bool:
	if disabled or not new_item:
		return false
	return color == Slot.Colors.NONE or new_item.color == color

func replace_item(new_item: ItemMechanic) -> ItemMechanic:
	var previous := item
	item = new_item
	update_ui()
	if color != Slot.Colors.NONE:
		item_changed.emit(item)
	return previous

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("shift_click") and item:
		quick_transfer_requested.emit(self)
		accept_event()

func _get_drag_data(_at_position: Vector2) -> Variant:
	if not item:
		return null
	var preview: TextureRect = duplicate()
	var c = Control.new()
	preview.texture = null
	#preview.position -= Vector2(32, 8)
	c.rotation = deg_to_rad(-30)
	c.modulate = Color(c.modulate, 0.5)
	c.add_child(preview)
	set_drag_preview(c)
	var drag_data = ItemDragDataScript.new(item, weakref(self), color, entity_id)
	replace_item(null)
	return drag_data

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if not _is_item_drag_data(data):
		return false
	var drag_data = data
	if not drag_data.item or not can_accept_item(drag_data.item):
		return false
	if not item:
		return true
	var source: ItemSlot = drag_data.get_source_slot()
	if not source or source == self:
		return false
	return source.can_accept_item(item)

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	if not _is_item_drag_data(data):
		return
	var drag_data = data
	if not drag_data.item:
		return
	var outgoing := replace_item(drag_data.item)
	drag_data.item = null
	if outgoing:
		var source: ItemSlot = drag_data.get_source_slot()
		if source and source != self and source.can_accept_item(outgoing):
			drag_data.item = source.replace_item(outgoing)
		else:
			drag_data.item = outgoing

func swap_item_with(slot: ItemSlot) -> void:
	if self == slot:
		update_ui()
		slot.update_ui()
		return
	var displaced := replace_item(slot.item)
	slot.replace_item(displaced)

func _is_item_drag_data(data: Variant) -> bool:
	return data is RefCounted and data.get_script() == ItemDragDataScript
