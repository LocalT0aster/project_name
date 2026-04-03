extends Button


func _on_mouse_entered() -> void:
	if Input.is_action_pressed("left_mouse_click"):
		button_pressed = true
