extends CharacterFSM

## Multiples of PI
@export var angle_pi_rad: float = 1.0

func _ready() -> void:
	super ()
	character.rotation = PI * angle_pi_rad

func _exit_tree() -> void:
	character.rotation = 0.0
