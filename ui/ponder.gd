extends Button

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var dil : String = "test1"

func _on_pressed() -> void:
	if Dialogic.current_timeline != null:
		Dialogic.end_timeline()
	Dialogic.start(dil)
	animation_player.stop()

func new_thing():
	animation_player.play("Blink")
