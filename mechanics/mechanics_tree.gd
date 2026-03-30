class_name MechanicsTree
extends Node

@export var default_slots: Array[PackedScene]
@export var loaded: Array[FSM]

func _ready() -> void:
	MechanicManager.object_tree[get_parent().name] = self
	for s in default_slots:
		var fsm = s.instantiate() as FSM
		loaded.append(fsm)
		add_child(fsm)

func set_slot(index: int, scene: PackedScene) -> void:
	if index >= default_slots.size() or index < 0:
		printerr("MechanicsTree: got out of bounds index")
	if loaded[index]:
		loaded[index].process_mode = Node.PROCESS_MODE_DISABLED
		loaded[index].queue_free()
	if not scene:
		scene = default_slots[index]
	var fsm = scene.instantiate() as FSM
	loaded.append(fsm)
	add_child(fsm)
