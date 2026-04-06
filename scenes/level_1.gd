extends Node2D

func _ready() -> void:
	if Dialogic.current_timeline != null:
		return
	Dialogic.start('level1')
	get_viewport().set_input_as_handled()
