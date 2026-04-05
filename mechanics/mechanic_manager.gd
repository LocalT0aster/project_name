extends Node

## Global dict of entities crafted
@export var entity_trees: Dictionary[int, MechanicsTree] = {}

const MECHANIC_TREE_GROUP: StringName = &"MechanicEntity"

# signal entity_update(entity_id: int) ## ?
signal entity_removed(entity_id: int) ## Called when the entity is exiting tree

## Initialize [member entitiy_trees] upon entering the tree
func _ready() -> void:
	entity_trees.clear()
	## print(get_tree().get_nodes_in_group(MECHANIC_TREE_GROUP))
	for e in get_tree().get_nodes_in_group(MECHANIC_TREE_GROUP):
		entity_trees[e.get_instance_id()]=e
		## on [signal tree_exiting] parent of [class MechanicTree]
		e.get_parent().tree_exiting.connect(_on_entity_exiting.bind(e))

## Handle entity's [signal tree_exiting]
func _on_entity_exiting(entity: MechanicsTree) -> void:
	entity_removed.emit(entity.get_instance_id())
	entity_trees.erase(entity.get_instance_id())
