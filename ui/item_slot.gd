extends TextureRect

@onready var icon: TextureRect = $Icon
@export var item : Item#:
	#set(value):
		#item_changed.emit(item)
		#item = value
@export_enum("blue", "yellow") var slot : String
@export var fsm : PackedScene
@export var entity: StringName
@export var slot_index: int = 0
@export var default_mech : String = "Idle"
@export var disabled : bool

#signal item_changed(item: Item)

func set_slot_mechanic(item: Item):
	if (not entity) or (entity == "") or (not slot) or (slot == "") or (not MechanicManager.object_tree[entity]):
		return
	if item:
		MechanicManager.object_tree[entity].set_slot(slot_index, item.mechanic)
	else:
		MechanicManager.object_tree[entity].set_slot(slot_index, null)

func _ready() -> void:
	#item_changed.connect(set_slot_mechanic)
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
	var preview : TextureRect = duplicate()
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
	if (slot != "" and data.item.slot != slot) or disabled: return false
	return true

func _drop_data(_at_position: Vector2, data: Variant) -> void:
	var tmp = item
	item = data.item
	if slot and slot != "":
		set_slot_mechanic(item)
	elif data.slot and data.slot != "":
		data.set_slot_mechanic(tmp)
	data.item = tmp
	#icon.show()
	#data.icon.show()
	update_ui()
	data.update_ui()
