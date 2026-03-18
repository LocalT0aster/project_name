extends Area2D

var dialog : Dictionary = {
	
}

func start_dil() -> Dictionary:
	return dialog

func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		pass
