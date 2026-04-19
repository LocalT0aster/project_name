extends Node
class_name State

## Base class for states managed by an [FSM].
##
## Child classes override the lifecycle callbacks to implement behavior and
## optionally request a transition by returning the next state's lowercase
## name. Return `null` to remain in the current state.

## Normalizes the node name so it can be used as a stable lowercase state key.
## The state names MUST be lowercase
func _ready() -> void:
	name = name.to_lower()

## Runs when this state becomes active.
## [br][br]
## [b]Returns[/b]: the next state's name to transition, or `null` to remain active.
func enter() -> Variant:
	return null

## Runs when this state stops being active.
func exit() -> void:
	return

## Runs every rendered frame while this state is active.
## [br][br]
## [b]Returns[/b]: the next state's name to transition, or `null` to remain active.
func update(_delta : float) -> Variant:
	return null

## Runs on every physics tick while this state is active.
## [br][br]
## [b]Returns[/b]: the next state's name to transition, or `null` to remain active.
func physics_update(_delta : float) -> Variant:
	return null

## Runs for unhandled input while this state is active.
## [br][br]
## [b]Returns[/b]: the next state's name to transition, or `null` to remain active.
func unhandled_event(_event: InputEvent) -> Variant:
	return null

## Runs for all input events while this state is active.
## [br][br]
## [b]Returns[/b]: the next state's name to transition, or `null` to remain active.
func event(_event: InputEvent) -> Variant:
	return null
