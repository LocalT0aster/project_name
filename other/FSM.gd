extends Node
class_name FSM

## Simple finite-state machine that owns [State] children.
##
## Each child [State] is indexed by its lowercase node name. The active state
## may request a transition by returning another state's name from any of its
## lifecycle callbacks.

## State entered first when the machine becomes ready.
@export var initial_state: State

## All registered states keyed by lowercase node name.
var states: Dictionary[StringName, State] = {}
## Currently active state, or `null` before initialization completes.
var current_state: State = null

## [ItemMechanic] (card) that corresponds to this [FSM]'s scene.
@export var representative_item: ItemMechanic = null

## Registers child states and enters [member initial_state] when present.
func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name] = child
	
	if initial_state:
		current_state = initial_state
		_check_next_state(initial_state.enter())

## Forwards the render-frame update to the active state.
func _process(delta: float) -> void:
	if current_state:
		_check_next_state(current_state.update(delta))

## Forwards the physics-frame update to the active state.
func _physics_process(delta: float) -> void:
	if current_state:
		_check_next_state(current_state.physics_update(delta))

## Forwards unhandled input to the active state.
func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		_check_next_state(current_state.unhandled_event(event))

## Forwards input to the active state.
func _input(event: InputEvent) -> void:
	if current_state:
		_check_next_state(current_state.event(event))

## Forces a transition to [param new_state_name] without waiting for a callback.
func force_transition(new_state_name: StringName) -> void:
	transition(current_state, new_state_name)

## Applies a requested transition if it was issued by the active state.
func transition(state: State, new_state_name: StringName) -> void:
	if state != current_state:
		return

	var new_state = states.get(new_state_name)
	if !new_state:
		return
	
	if current_state:
		current_state.exit()

	current_state = new_state
	_check_next_state(new_state.enter())

## Transitions when a state callback returns a target state name.
func _check_next_state(next_state_name: Variant) -> void:
	if next_state_name == null or next_state_name == &"":
		return

	transition(current_state, next_state_name as StringName)
