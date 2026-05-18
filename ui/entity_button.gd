class_name EntityButton
extends Button
## Button that selects an entity inspector and supports drag-over switching.

## Name shown beside the icon without affecting the button minimum width.
@export var display_text: String = "":
	set(value):
		if display_text == value:
			return
		display_text = value
		tooltip_text = display_text
		if _marquee:
			_marquee.text = display_text

## Instance ID of the represented [MechanicsTree].
@export var entity_id: int = 0
## WeakRef to the owning [MechanicPanel].
var drag_data_ref: WeakRef = null

var _marquee: MarqueeLabel
var _last_draw_mode: int = -1
var _last_size: Vector2 = Vector2.INF


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


## Updates the visible entity name.
func set_display_text(value: String) -> void:
	display_text = value


func _on_mouse_entered() -> void:
	# Press button when dragging item over button
	var panel: MechanicPanel = null
	if drag_data_ref:
		panel = drag_data_ref.get_ref() as MechanicPanel
	if Input.is_action_pressed("left_mouse_click") and panel and panel.has_active_drag():
		button_pressed = true
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

	_marquee.position = Vector2(text_x, top)
	_marquee.size = Vector2(max(size.x - text_x - right, 0.0), max(size.y - top - bottom, 0.0))


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
