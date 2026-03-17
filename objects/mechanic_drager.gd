extends StaticBody2D

var enabled := false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if enabled:
		global_position = get_global_mouse_position()
