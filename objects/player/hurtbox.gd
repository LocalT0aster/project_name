extends Area2D

func _on_hurtbox_body_entered(body: Node2D) -> void:
	if body == self or !body.has_method("hurt"): return
	if body.is_in_group("enemy"): return
	body.hurt(1.0,Vector2.ZERO)

func _on_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
