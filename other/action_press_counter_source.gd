class_name ActionPressCounterSource
extends Node

## Registers a scene-local list of actions for the ActionPressCounter autoload.

## If false, the source stays registered but no actions are counted.
@export var enabled: bool = true

## InputMap actions counted once when they become pressed.
@export var actions: Array[StringName] = [&"up", &"left", &"right", &"down", &"jump"]


func _enter_tree() -> void:
	ActionPressCounter.register_source(self)


func _exit_tree() -> void:
	ActionPressCounter.unregister_source(self)
