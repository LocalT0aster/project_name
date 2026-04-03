extends Control

@export var entities_cont : Control
@export var slots_cont : Control

var entities : Dictionary
var slots : Dictionary
#entities and slots should have similar names
func _ready() -> void:
	for button in entities_cont.get_children():
		entities[button.name.to_lower()] = button
		button.toggled.connect(on_button_toggle.bind(button.name))
	for slot in slots_cont.get_children():
		slots[slot.name.to_lower()] = slot

func on_button_toggle(togled_on : bool, button_name : String):
	for slot in slots_cont.get_children():
		slot.hide()
	if !togled_on: return
	for button in entities.keys():
		if button == button_name.to_lower(): continue
		entities[button].button_pressed = false
	slots.get(button_name.to_lower()).show()

var data_bk
func _notification (what: int) -> void:
	if what == Node. NOTIFICATION_DRAG_BEGIN:
		data_bk = get_viewport().gui_get_drag_data()
	if what == Node. NOTIFICATION_DRAG_END:
		if not is_drag_successful():
			if data_bk:
				data_bk.update_ui()
				data_bk = null

func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	return false
