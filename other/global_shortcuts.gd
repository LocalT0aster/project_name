extends Node

const TOGGLE_FULLSCREEN_ACTION: StringName = &"toggle_fullscreen"
const RELOAD_SCENE_ACTION: StringName = &"reload_scene"

func _shortcut_input(event: InputEvent) -> void:
	if event.is_action_pressed(TOGGLE_FULLSCREEN_ACTION):
		_toggle_fullscreen()
		get_viewport().set_input_as_handled()

	elif event.is_action_pressed(RELOAD_SCENE_ACTION):
		var err: Error = get_tree().reload_current_scene()
		if err != OK:
			push_warning("Reload failed: %s" % err)
		get_viewport().set_input_as_handled()


func _toggle_fullscreen() -> void:
	get_window().mode = Window.MODE_WINDOWED if get_window().mode == Window.MODE_FULLSCREEN else Window.MODE_FULLSCREEN
