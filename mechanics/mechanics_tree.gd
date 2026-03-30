class_name MechanicsTree
extends Node

@export var slots: Array[PackedScene]

func _ready() -> void:
	MechanicManager.object_tree[get_parent().name] = self
