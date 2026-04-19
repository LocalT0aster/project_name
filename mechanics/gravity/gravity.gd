extends CharacterFSM

func _ready() -> void:
	super ()
	character.rotation = PI

func _exit_tree() -> void:
	character.rotation = 0.0
