class_name MarqueeLabelButton
extends Button
## Button that displays clipped marquee text without affecting minimum width.

## Name shown beside the icon.
@export var display_text: String = "":
	set(value):
		if display_text == value:
			return
		display_text = value
		tooltip_text = display_text
		if _marquee:
			_marquee.text = display_text

## Fastest marquee scroll speed in pixels per second.
@export var marquee_max_speed: float = 16.0:
	set(value):
		marquee_max_speed = max(value, 0.0)
		_apply_marquee_settings()

## Marquee acceleration and braking in pixels per second squared.
@export var marquee_acceleration: float = 8.0:
	set(value):
		marquee_acceleration = max(value, 1.0)
		_apply_marquee_settings()

## Time to pause after the text stops at either edge.
@export var marquee_stop_pause: float = 1.0:
	set(value):
		marquee_stop_pause = max(value, 0.0)
		_apply_marquee_settings()

## Extra vertical pixels around the text clip rect to keep descenders visible.
@export var marquee_vertical_bleed: float = 2.0:
	set(value):
		marquee_vertical_bleed = max(value, 0.0)
		_sync_marquee()

var _marquee: MarqueeLabel
var _last_draw_mode: int = -1
var _last_size: Vector2 = Vector2.INF

var marquee_edge_pause: float:
	set(value):
		marquee_stop_pause = value
	get:
		return marquee_stop_pause


func _ready() -> void:
	if display_text.is_empty() and not text.is_empty():
		display_text = text
	text = ""
	alignment = HORIZONTAL_ALIGNMENT_LEFT
	_ensure_marquee()
	_marquee.text = display_text
	tooltip_text = display_text
	_sync_marquee()
	set_process(true)


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_RESIZED, NOTIFICATION_THEME_CHANGED:
			_sync_marquee()


func _process(_delta: float) -> void:
	if not text.is_empty():
		set_display_text(text)
		text = ""
	if get_draw_mode() != _last_draw_mode or size != _last_size:
		_sync_marquee()


## Updates the visible button name.
func set_display_text(value: String) -> void:
	display_text = value


func _on_mouse_entered() -> void:
	_sync_marquee()


func _on_mouse_exited() -> void:
	_sync_marquee()


func _ensure_marquee() -> void:
	if _marquee:
		return
	_marquee = MarqueeLabel.new()
	_marquee.name = "DisplayName"
	_marquee.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(_marquee)
	_apply_marquee_settings()


func _apply_marquee_settings() -> void:
	if not _marquee:
		return
	_marquee.max_speed = marquee_max_speed
	_marquee.acceleration = marquee_acceleration
	_marquee.stop_pause = marquee_stop_pause


func _sync_marquee() -> void:
	if not is_inside_tree():
		return
	_ensure_marquee()
	_layout_marquee()
	_sync_marquee_style()
	_last_draw_mode = get_draw_mode()
	_last_size = size


func _layout_marquee() -> void:
	var stylebox: StyleBox = get_theme_stylebox(_stylebox_name())
	var left: float = stylebox.get_margin(SIDE_LEFT)
	var right: float = stylebox.get_margin(SIDE_RIGHT)
	var top: float = stylebox.get_margin(SIDE_TOP)
	var bottom: float = stylebox.get_margin(SIDE_BOTTOM)
	var text_x: float = left

	if icon:
		text_x += icon.get_width()
		if not display_text.is_empty():
			text_x += get_theme_constant(&"h_separation")

	var text_height: float = max(size.y - top - bottom, 0.0)
	var marquee_height: float = max(
			text_height + marquee_vertical_bleed * 2.0,
			_get_font_height() + marquee_vertical_bleed * 2.0
	)
	var marquee_y: float = max(top + (text_height - marquee_height) * 0.5, 0.0)
	_marquee.position = Vector2(text_x, marquee_y)
	_marquee.size = Vector2(
			max(size.x - text_x - right, 0.0),
			max(marquee_height, 0.0)
	)


func _sync_marquee_style() -> void:
	_marquee.set_text_style(
			get_theme_font(&"font"),
			get_theme_font_size(&"font_size"),
			get_theme_color(_font_color_name())
	)


func _stylebox_name() -> StringName:
	match get_draw_mode():
		DRAW_DISABLED:
			return &"disabled"
		DRAW_PRESSED:
			return &"pressed"
		DRAW_HOVER:
			return &"hover"
		DRAW_HOVER_PRESSED:
			return &"hover_pressed"
		_:
			return &"normal"


func _font_color_name() -> StringName:
	match get_draw_mode():
		DRAW_DISABLED:
			return &"font_disabled_color"
		DRAW_PRESSED:
			return &"font_pressed_color"
		DRAW_HOVER:
			return &"font_hover_color"
		DRAW_HOVER_PRESSED:
			return &"font_hover_pressed_color"
		_:
			return &"font_color"


func _get_font_height() -> float:
	var font: Font = get_theme_font(&"font")
	if not font:
		return 0.0
	return font.get_height(get_theme_font_size(&"font_size"))
