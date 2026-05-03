class_name BaseLevel
extends Node2D

@export var panel: MechanicPanel

const SCRIPT_ID: StringName = &"BaseLevel"

func _ready() -> void:
	if not panel:
		printerr("Where MechanicPanel?")
	init()

func init() -> void:
	MechanicManager.init()
	for e in MechanicManager.entity_trees.values():
		e.init()
	if panel:
		panel.init()
	else:
		printerr("Where MechanicPanel?")
	print(SCRIPT_ID + " init")
