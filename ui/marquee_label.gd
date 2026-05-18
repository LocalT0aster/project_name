class_name MarqueeLabel
extends Control
## Clipped single-line label that ping-pong scrolls when its text overflows.

## Displayed text.
@export var text: String = "":
	set(value):
		if text == value:
			return
		text = value
		_reset_motion()
		_refresh_label()

## Fastest scroll speed in pixels per second.
@export var max_speed: float = 32.0:
	set(value):
		max_speed = max(value, 0.0)

## Scroll acceleration and braking in pixels per second squared.
@export var acceleration: float = 96.0:
	set(value):
		acceleration = max(value, 1.0)

## Time to pause after stopping at either edge.
@export var stop_pause: float = 0.75:
	set(value):
		stop_pause = max(value, 0.0)

var edge_pause: float:
	set(value):
		stop_pause = value
	get:
		return stop_pause

var _label: Label
var _text_width: float = 0.0
var _text_height: float = 0.0
var _scroll_offset: float = 0.0
var _direction: float = 1.0
var _speed: float = 0.0
var _pause_remaining: float = 0.0


func _init() -> void:
	clip_contents = true
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	set_process(false)


func _ready() -> void:
	_ensure_label()
	_refresh_label()


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_RESIZED, NOTIFICATION_THEME_CHANGED:
			_update_metrics()


func _process(delta: float) -> void:
	if _pause_remaining > 0.0:
		_pause_remaining = max(_pause_remaining - delta, 0.0)
		if _pause_remaining > 0.0:
			return

	var target: float = _max_scroll() if _direction > 0.0 else 0.0
	var distance: float = abs(target - _scroll_offset)
	if distance <= 0.5:
		_arrive_at_edge(target)
		return

	var desired_speed: float = min(max_speed, sqrt(2.0 * acceleration * distance))
	_speed = move_toward(_speed, desired_speed, acceleration * delta)
	var step: float = _speed * delta
	if step >= distance:
		_arrive_at_edge(target)
		return

	var step_direction: float = 1.0 if target > _scroll_offset else -1.0
	_scroll_offset += step_direction * step
	_apply_offset()


func _get_minimum_size() -> Vector2:
	return Vector2.ZERO


## Applies theme values from the host control.
func set_text_style(font: Font, font_size: int, font_color: Color) -> void:
	_ensure_label()
	if font:
		_label.add_theme_font_override(&"font", font)
	_label.add_theme_font_size_override(&"font_size", font_size)
	_label.add_theme_color_override(&"font_color", font_color)
	_update_metrics()


func _ensure_label() -> void:
	if _label:
		return
	_label = Label.new()
	_label.name = "Text"
	_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	add_child(_label)


func _refresh_label() -> void:
	_ensure_label()
	_label.text = text
	_update_metrics()


func _update_metrics() -> void:
	if not _label:
		return
	_text_width = _measure_text_width()
	_text_height = _measure_text_height()
	var max_scroll: float = _max_scroll()
	if _scroll_offset > max_scroll:
		_scroll_offset = max_scroll

	if max_scroll <= 0.5:
		_reset_motion()
		set_process(false)
	else:
		set_process(true)
	_apply_offset()


func _measure_text_width() -> float:
	var font: Font = _label.get_theme_font(&"font")
	var font_size: int = _label.get_theme_font_size(&"font_size")
	if font:
		return font.get_string_size(text, HORIZONTAL_ALIGNMENT_LEFT, -1.0, font_size).x
	return _label.get_combined_minimum_size().x


func _measure_text_height() -> float:
	var font: Font = _label.get_theme_font(&"font")
	var font_size: int = _label.get_theme_font_size(&"font_size")
	if font:
		return font.get_height(font_size)
	return _label.get_combined_minimum_size().y


func _max_scroll() -> float:
	return max(_text_width - size.x, 0.0)


func _apply_offset() -> void:
	if not _label:
		return
	var label_height: float = max(size.y, _text_height)
	_label.position = Vector2(-round(_scroll_offset), floor((size.y - label_height) * 0.5))
	_label.size = Vector2(max(size.x, _text_width), label_height)


func _arrive_at_edge(target: float) -> void:
	_scroll_offset = target
	_speed = 0.0
	_direction *= -1.0
	_pause_remaining = stop_pause
	_apply_offset()


func _reset_motion() -> void:
	_scroll_offset = 0.0
	_direction = 1.0
	_speed = 0.0
	_pause_remaining = 0.0
