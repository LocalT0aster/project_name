class_name EntityButton
extends Button

## Instace ID of the MechanicTree
@export var entity_id: int = 0
## WeakRef to the drag_data in MechanicsPanel
var drag_data_ref: WeakRef = null

func _on_mouse_entered() -> void:
	# Press button when dragging item over button
	if Input.is_action_pressed("left_mouse_click") and ((drag_data_ref and drag_data_ref.get_ref()) or not drag_data_ref):
		button_pressed = true
