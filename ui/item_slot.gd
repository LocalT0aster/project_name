class_name ItemSlot
extends TextureRect

@onready var icon: TextureRect = $Icon
@export var item: ItemMechanic = null
@export var color: Slot.Colors = Slot.Colors.NONE
@export var disabled: bool = false

signal item_changed(item: ItemMechanic)

var color_texture: Dictionary[Slot.Colors, Texture2D] = {
	Slot.Colors.NONE: preload("res://img/itemslot.png"),
	Slot.Colors.BLUE: preload("res://img/blueMechanicSlot.png"),
	Slot.Colors.YELLOW: preload("res://img/yellowMechanicSlot.png"),
	Slot.Colors.GREEN: preload("res://img/greenMechanicSlot.png")
}

func _ready() -> void:
	texture = color_texture[color]
	update_ui()

func update_ui() -> void:
	if item == null:
		if icon:
			icon.texture = null
			icon.hide()
		return
	if icon:
		icon.show()
		icon.texture = item.sprite
	tooltip_text = item.mechanic_name

func _get_drag_data(_at_position: Vector2) -> Variant:
	if not item:
		return
	var preview: TextureRect = duplicate()
	var c = Control.new()
	preview.texture = null
	#preview.position -= Vector2(32, 8)
	c.rotation = deg_to_rad(-30)
	c.modulate = Color(c.modulate, 0.5)
	c.add_child(preview)
	set_drag_preview(c)
	icon.hide()
	return self

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if (color != Slot.Colors.NONE and data.item.color != color) or disabled: return false
	return true

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	swap_item_with(data)

func swap_item_with(slot: ItemSlot) -> void:
	if self == slot:
		return
	var tmp = item
	item = slot.item
	if color != Slot.Colors.NONE:
		item_changed.emit(item)
	elif slot.color != Slot.Colors.NONE:
		slot.item_changed.emit(tmp)
	slot.item = tmp
	update_ui()
	slot.update_ui()
