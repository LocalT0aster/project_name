class_name BaseLevel
extends Node2D

const LEVEL_NAME: StringName = &"Level"
const SCRIPT_ID: StringName = &"BaseLevel"

func _ready() -> void:
	LoadManager.get_ordering().loaded[SCRIPT_ID] = self
	if name != LEVEL_NAME:
		printerr('Please use name "Level" for root level node')
