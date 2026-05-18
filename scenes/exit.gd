extends Sprite2D

@export_file("*.tscn") var scene: String

const PLAYER_GROUP_STR: StringName = &"player"
const CHANGE_SCENE_METHOD: StringName = &"change_scene_to_file"

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !body.is_in_group(PLAYER_GROUP_STR) or not scene: return
	SceneSwitcher.call_deferred("switch_scene", scene)
	#get_tree().call_deferred(CHANGE_SCENE_METHOD, scene)
