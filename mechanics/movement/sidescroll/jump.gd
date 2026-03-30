extends MovementStateSS

@export var jump_velocity = -400

func enter():
	super()
	parent.character.velocity.y = jump_velocity
	transition.emit(self, "walk")

func _physics_process(delta: float) -> void:
	transition.emit(self, "walk")
