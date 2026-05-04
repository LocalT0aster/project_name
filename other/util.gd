extends RefCounted
class_name Util

const _SIGNAL: StringName = &"signal"
const _CALLABLE: StringName = &"callable"

## Disconnects all [Callable]s from the given [param sig].[br]
## Returns: [code]true[/code] when [method Signal.has_connections].
static func disconnect_all(sig: Signal) -> bool:
	if not sig.has_connections():
		return false
	for connection in sig.get_connections():
		if connection.get(_SIGNAL) and connection.get(_CALLABLE):
			(connection[_SIGNAL] as Signal).disconnect(connection[_CALLABLE])
	return true

## Disconnects every [Callable] from the given [param sig], and connects the [param callable].[br]
## Returns: [code]true[/code] when [method Signal.has_connections].
static func connect_only(sig: Signal, callable: Callable) -> bool:
	var was_connected: bool = sig.has_connections()
	if was_connected:
		disconnect_all(sig)
	sig.connect(callable)
	return was_connected

## Reconnects the [param callable] to the [param sig].
## Returns: [code]true[/code] when [method Signal.is_connected] to the [param callable].
static func reconnect(sig: Signal, callable: Callable) -> bool:
	var was_connected: bool = sig.is_connected(callable)
	if was_connected:
		sig.disconnect(callable)
	sig.connect(callable)
	return was_connected
