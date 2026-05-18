class_name MechanicPresenceDetectorSource
extends Node
## Scene-level configuration for the MechanicPresenceDetector autoload.

## If false, the detector publishes an absent result for this source.
@export var enabled: bool = true

## MechanicsTree to scan, usually the level's player.
@export var mechanics_tree_path: NodePath = ^"../../player/MechanicsTree"

## FSM scene to look for in the selected MechanicsTree.
@export var target_mechanic: PackedScene

## Slot color to scan; [constant Slot.Colors.NONE] scans all colored slots.
@export var slot_color: Slot.Colors = Slot.Colors.NONE

## Dialogic variable prefix for the published present/count/slot values.
@export var dialogic_variable_prefix: String = "target_mechanic"


func _enter_tree() -> void:
	MechanicPresenceDetector.register_source(self)


func _exit_tree() -> void:
	MechanicPresenceDetector.unregister_source(self)
