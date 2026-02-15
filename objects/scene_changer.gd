extends ColorRect

var scene : PackedScene = null

func _ready() -> void:
	cp.change_scene.connect(change_scene)
	show()
	$AnimationPlayer.play_backwards("fade")

func change_scene(scene_path: String) -> void:
	main.previous_scene = get_tree().current_scene.scene_file_path
	scene = load(scene_path)
	$AnimationPlayer.play("fade")

func previous_scene() -> void:
	scene = load(main.previous_scene)
	$AnimationPlayer.play("fade")

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	if scene:
		get_tree().change_scene_to_packed(scene)
