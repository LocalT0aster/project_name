class_name LoadOrdering
extends Node

var loaded: Dictionary[StringName, Node] = {}

const SCRIPT_ID: StringName = &"LoadOrdering"

func _ready() -> void:
	get_tree().get_root().ready.connect(init)

func init() -> void:
	if not loaded.get(MechanicManager.SCRIPT_ID):
		MechanicManager._ready()
		MechanicManager.ready.emit()
	if loaded.get(MechanicPanel.SCRIPT_ID):
		loaded[MechanicManager.SCRIPT_ID].init()
		for e in MechanicManager.entity_trees.values():
			e.init()
		loaded[MechanicPanel.SCRIPT_ID].init()
	else:
		printerr("Where MechanicPanel?")
	print("LoadOrdering ready")
	loaded[SCRIPT_ID] = self
