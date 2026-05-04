class_name EntityButton
extends Button

## Instace ID of the MechanicTree
@export var entity_id: int = 0
## WeakRef to the owning [MechanicPanel].
var drag_data_ref: WeakRef = null

func _on_mouse_entered() -> void:
	# Press button when dragging item over button
	var panel: MechanicPanel = null
	if drag_data_ref:
		panel = drag_data_ref.get_ref() as MechanicPanel
	if Input.is_action_pressed("left_mouse_click") and panel and panel.has_active_drag():
		button_pressed = true
