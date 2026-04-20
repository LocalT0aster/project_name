class_name BaseLevel
extends Node2D

@export var panel: MechanicPanel

const LEVEL_NAME: StringName = &"Level"
const SCRIPT_ID: StringName = &"BaseLevel"

func _ready() -> void:
	if name != LEVEL_NAME:
		name = LEVEL_NAME
		printerr('Please use name "Level" for root level node')
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
