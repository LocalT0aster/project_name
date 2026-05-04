extends CanvasLayer

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var scene_path : String = ""

func switch_scene(path):
	scene_path = path
	animation_player.play("fade")

func finish_switch():
	if scene_path == "": return
	get_tree().change_scene_to_file(scene_path)
	scene_path = ""
	animation_player.play_backwards("fade")
