extends Control

var tween : Tween

var _rolled_in: bool = false ## Used for _resize_adjustment

func _ready() -> void:
	var r_size = get_viewport().get_visible_rect().size
	position = Vector2(r_size.x,0)
	resized.connect(_resize_adjustment)

func _resize_adjustment() -> void:
	if not _rolled_in:
		reset_tween()
		var r_size = get_viewport().get_visible_rect().size
		position = Vector2(r_size.x, 0)

func roll_in():
	reset_tween()
	tween = create_tween()
	tween.tween_property(self, "position", Vector2.ZERO, 0.5)

func roll_out():
	reset_tween()
	tween = create_tween()
	var r_size = get_viewport().get_visible_rect().size
	tween.tween_property(self, "position", Vector2(r_size.x,0), 0.5)

func reset_tween():
	if tween: tween.kill()

func _on_ide_toggled(toggled_on: bool) -> void:
	_rolled_in = toggled_on
	if toggled_on:
		roll_in()
	else:
		roll_out()
