extends Node

const SCRIPT_ID: StringName = &"LoadManager"

func _ready() -> void:
	print("LoadManager ready")
	LoadManager.get_ordering().loaded[SCRIPT_ID] = self

func get_ordering() -> LoadOrdering:
	return get_node("/root/Level/LoadOrdering") as LoadOrdering
