class_name CharacterState
extends State

## Binding of the character to the CharacterFSM value
var character: CharacterBody2D:
	get: return get_parent().character

var character_sprite: Sprite2D:
	get: return character.sprite

var c_up: Vector2:
	get: return get_parent().character.up_direction
	set(value): get_parent().character.up_direction = value
var c_right: Vector2:
	get: return get_parent().character.up_direction.rotated(PI * 0.5)
