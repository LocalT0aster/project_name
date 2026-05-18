extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export_file("*.tscn") var scene_path: String = ""

const ANIMATION_NAME: StringName = &"fade"

func switch_scene(path: String):
	scene_path = path
	animation_player.play(ANIMATION_NAME)

func finish_switch():
	if scene_path == "": return
	get_tree().change_scene_to_file(scene_path)
	scene_path = ""
	animation_player.play_backwards(ANIMATION_NAME)
