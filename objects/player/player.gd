extends CharacterBody2D

func hurt(_a, _b):
	queue_free()

@export var sprite: Sprite2D
@export var look_left_at_start: bool = false

func _ready() -> void:
	sprite.scale.x = -abs(sprite.scale.x) if look_left_at_start else abs(sprite.scale.x)
