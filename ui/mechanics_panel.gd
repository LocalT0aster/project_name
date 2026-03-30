extends Control

var entities : Dictionary
var slots : Dictionary
#entities and slots should have similar names
func _ready() -> void:
	for button in $Entities.get_children():
		entities[button.name.to_lower()] = button
		button.toggled.connect(on_button_toggle.bind(button.name))
	for slot in $Slots.get_children():
		slots[slot.name.to_lower()] = slot

func on_button_toggle(togled_on : bool, button_name : String):
	for slot in $Slots.get_children():
		slot.hide()
	if !togled_on: return
	for button in entities.keys():
		if button == button_name.to_lower(): continue
		entities[button].button_pressed = false
	slots.get(button_name.to_lower()).show()
