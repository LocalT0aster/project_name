extends Area2D

@export var label: Label
@export var sound: AudioStreamPlayer2D

const PLAYER_GROUP: StringName = &"player"

func _ready() -> void:
	label.hide()


func _on_body_entered(body: Node2D) -> void:
	if not body.is_in_group(PLAYER_GROUP):
		return
	var counter = get_tree().current_scene
	if not counter:
		return
	counter.score += 1
	label.text = str(counter.score)
	label.show()
	sound.play()
	set_deferred("process_mode", Node.PROCESS_MODE_DISABLED)
