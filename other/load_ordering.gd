class_name LoadOrdering
extends Node

var loaded: Dictionary[StringName, Node] = {}

const SCRIPT_ID: StringName = &"LoadOrdering"

func _ready() -> void:
	if not loaded.get(MechanicManager.SCRIPT_ID):
		MechanicManager._ready()
		MechanicManager.ready.emit()
	if loaded.get(MechanicPanel.SCRIPT_ID):
		loaded[MechanicManager.SCRIPT_ID].init()
		loaded[MechanicPanel.SCRIPT_ID].init()
	else:
		printerr("Where MechanicPanel?")
	print("LoadOrdering ready")
	LoadManager.get_ordering().loaded[SCRIPT_ID] = self
