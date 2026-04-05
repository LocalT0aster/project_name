class_name ItemSlot
extends TextureRect

@onready var icon: TextureRect = $Icon
@export var item: ItemMechanic = null
@export var color: Slot.Colors = Slot.Colors.NONE
@export var disabled: bool = false

signal item_changed(item: ItemMechanic)

func _ready() -> void:
	update_ui()

func update_ui() -> void:
	if item == null:
		icon.texture = null
		icon.hide()
		return
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
	var tmp = item
	item = data.item
	if color != Slot.Colors.NONE:
		item_changed.emit(item)
	elif data.color != Slot.Colors.NONE:
		data.item_changed.emit(tmp)
	data.item = tmp
	#icon.show()
	#data.icon.show()
	update_ui()
	data.update_ui()
