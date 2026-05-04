extends Area2D

@export var enabled : bool = true

func _input(_event: InputEvent) -> void:
	if !enabled or get_overlapping_areas().size() == 0: return
	if Input.is_action_pressed("interact"):
		print("ses")
		var dil = get_overlapping_areas()[0].dialog
		if Dialogic.current_timeline != null:
			Dialogic.end_timeline()
		Dialogic.start(dil)
	
