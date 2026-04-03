@tool
class_name ScaledScroll
extends ScrollContainer

@export var v_scale: Vector2 = Vector2.ONE
@export var h_scale: Vector2 = Vector2.ONE

func _ready() -> void:
	update()

func _process(delta: float) -> void:
	update()

func update() -> void:
	get_h_scroll_bar().scale = h_scale
	get_v_scroll_bar().scale = v_scale
