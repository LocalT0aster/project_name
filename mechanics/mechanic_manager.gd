extends Node

@export var entity_trees: Dictionary[int, MechanicsTree] = {}

const MECHANIC_TREE_GROUP: StringName = &"MechanicEntity"

func _ready() -> void:
	get_tree().get_nodes_in_group(MECHANIC_TREE_GROUP).all(
		func(x: MechanicsTree): entity_trees[x.get_instance_id()]=x; return true)
