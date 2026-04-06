extends Sprite2D

@export var scene : PackedScene

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !body.is_in_group("player") or not scene: return
	get_tree().call_deferred("change_scene_to_packed",scene)
