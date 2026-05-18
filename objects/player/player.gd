class_name Player
extends CharacterBody2D

func hurt(_a, _b):
	queue_free()

@export var sprite: Sprite2D
@export var look_left_at_start: bool = false
@export var slidin: bool = false
@export var display_name: StringName = &"player"

const KILL_GROUP: StringName = &"kill"

func _ready() -> void:
	sprite.scale.x = -abs(sprite.scale.x) if look_left_at_start else abs(sprite.scale.x)

func _physics_process(_delta: float) -> void:
	if slidin:
		for i in get_slide_collision_count():
			if get_slide_collision(i).get_collider().is_in_group(KILL_GROUP):
				queue_free()
