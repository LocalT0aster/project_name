extends CharacterBody2D

func hurt(_a, _b):
	queue_free()

@export var sprite : Sprite2D
