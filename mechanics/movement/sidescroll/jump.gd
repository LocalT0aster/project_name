extends MovementStateSS

func enter():
	super ()
	get_parent().character.velocity.y = - get_parent().jump_velocity
	transition.emit(self , "walk")

func _physics_process(_delta: float) -> void:
	transition.emit(self , "walk")
