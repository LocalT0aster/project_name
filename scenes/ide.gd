extends TextureButton

@export var anim : AnimationPlayer

func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		anim.play("roll_in")
	else:
		anim.play_backwards("roll_in")
