extends BaseLevel

func _ready() -> void:
	if Dialogic.current_timeline != null:
		Dialogic.end_timeline()
		# await get_tree().process_frame
	Dialogic.start('level1')
	get_viewport().set_input_as_handled()
	super ()
