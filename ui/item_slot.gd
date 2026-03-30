extends TextureRect

@onready var icon: TextureRect = $Icon
@export var item : Item:
	set(value):
		item_changed.emit(item)
		item = value
@export var type : String
@export var disabled : bool

signal item_changed(item : Item)

func _ready() -> void:
	update_ui()

func update_ui() -> void:
	if item == null:
		icon.texture = null
		icon.hide()
		return
	icon.show()
	icon.texture = item.sprite
	tooltip_text = item.item_name

func _get_drag_data(_at_position: Vector2) -> Variant:
	if not item:
		return
	var preview : TextureRect = duplicate()
	var c = Control.new()
	preview.texture = null
	preview.position -= Vector2(32, 8)
	c.rotation = deg_to_rad(-30)
	c.modulate = Color(c.modulate, 0.5)
	c.add_child(preview)
	set_drag_preview(c)
	icon.hide()
	return self

func _can_drop_data(_at_position: Vector2, data: Variant) -> bool:
	if (type != "" and data.item.slot != type) or disabled: return false
	return true

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var tmp = item
	item = data.item
	item_changed.emit(item)
	data.item = tmp
	#icon.show()
	#data.icon.show()
	update_ui()
	data.update_ui()
