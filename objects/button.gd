extends Area2D

var dead : bool = false

signal toggled(on : bool)

func _on_body_entered(_body: Node2D) -> void:
	if dead: return
	toggled.emit(true)
	$pressed.show()
	$default.hide()

func _on_body_exited(_body: Node2D) -> void:
	if dead or get_overlapping_bodies().size() != 0: return
	toggled.emit(false)
	$pressed.hide()
	$default.show()

func hurt(_damage, _stuff):
	toggled.emit(true)
	dead = true
	$broken.show()
	$default.hide()
	$broken.hide()
