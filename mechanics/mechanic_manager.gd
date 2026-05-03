extends Node

## Global dict of entities crafted
@export var entity_trees: Dictionary[int, MechanicsTree] = {}

const MECHANIC_TREE_GROUP: StringName = &"MechanicEntity"

signal entity_update(entity_id: int) ## Called when entity is created/updated
signal entity_removed(entity_id: int) ## Called when the entity is exiting tree

var _instantiated: bool = true

const SCRIPT_ID: StringName = &"MechanicManager"

func _ready() -> void:
	# init()
	print(SCRIPT_ID + " ready")
	#LoadManager.get_ordering().loaded[SCRIPT_ID] = self

func init() -> void:
	entity_trees.clear()
	for e in get_tree().get_nodes_in_group(MECHANIC_TREE_GROUP):
		entity_trees[e.get_instance_id()] = e
		## on [signal tree_exiting] parent of [class MechanicTree]
		if e.get_parent().tree_exiting.has_connections():
			e.get_parent().tree_exiting.disconnect(_on_entity_exiting)
		e.get_parent().tree_exiting.connect(_on_entity_exiting.bind(e))
	print(SCRIPT_ID + " init")

func _notification(what: int) -> void:
	match what:
		Node.NOTIFICATION_SCENE_INSTANTIATED:
			print("MechanicManager NOTIFICATION_SCENE_INSTANTIATED")
			if _instantiated:
				print("I played this game before!")
		Node.NOTIFICATION_POST_ENTER_TREE:
			print("MechanicManager NOTIFICATION_POST_ENTER_TREE")

## Handle entity's [signal tree_exiting]
func _on_entity_exiting(entity: MechanicsTree) -> void:
	entity_removed.emit(entity.get_instance_id())
	entity_trees.erase(entity.get_instance_id())
