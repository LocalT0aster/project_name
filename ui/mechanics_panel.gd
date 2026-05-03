class_name MechanicPanel
extends Control

@export var entity_button: PackedScene = preload("res://ui/entity_button.tscn")
@export var entity_inspector: PackedScene = preload("res://ui/entity_inspector.tscn")

@export var entities_container: Control
@export var inspectors_container: Control
@export var inventory_container: Control

@export var death_msg: Label

var _id2button: Dictionary[int, EntityButton] = {}
var _id2inspector: Dictionary[int, EntityInspector] = {}

const _MECHANIC_TREE_PATH: NodePath = ^"./MechanicsTree"
const SCRIPT_ID: StringName = &"MechanicPanel"

func _ready() -> void:
	# init()
	print("MechanicPanel ready")

func init() -> void:
	# Free containers from predefined children (mock ui entries)
	for c in entities_container.get_children(): c.queue_free()
	for c in inspectors_container.get_children(): c.queue_free()
	
	Util.connect_only(MechanicManager.entity_removed, _on_entity_remove)
	Util.connect_only(MechanicManager.entity_update, _on_entity_update)

	# Instantiate new entity entries
	for id in MechanicManager.entity_trees.keys():
		_init_entity_button(id)
		_init_entity_inspector(id)
	if %player:
		_id2button[%player.get_node(_MECHANIC_TREE_PATH).get_instance_id()].button_pressed = true
		%player.tree_exited.connect(_on_player_dead)

## Initialize EntityButton
func _init_entity_button(id: int) -> EntityButton:
	var btn: EntityButton = entity_button.instantiate()
	btn.text = MechanicManager.entity_trees[id].e_name
	btn.name = MechanicManager.entity_trees[id].e_name
	btn.toggled.connect(on_button_toggle.bind(id))
	btn.entity_id = id
	btn.drag_data_ref = weakref(drag_data)
	_id2button[id] = btn
	entities_container.add_child(btn)
	return btn

## Initialize EntityInspector
func _init_entity_inspector(id: int) -> EntityInspector:
	var ins: EntityInspector = entity_inspector.instantiate()
	ins.name = MechanicManager.entity_trees[id].e_name
	ins.entity_id = id
	ins.inventory_ref = weakref(inventory_container)
	ins.init_slots()
	_id2inspector[id] = ins
	ins.visible = false
	inspectors_container.add_child(ins)
	return ins
	

func on_button_toggle(togled_on: bool, entity_id: int):
	for i in inspectors_container.get_children():
		i.hide()
	if !togled_on: return
	for btn in entities_container.get_children():
		if btn.entity_id == entity_id: continue
		btn.button_pressed = false
	_id2inspector[entity_id].show()


var drag_data
func _notification(what: int) -> void:
	match what:
		Node.NOTIFICATION_DRAG_BEGIN:
			drag_data = get_viewport().gui_get_drag_data()
		Node.NOTIFICATION_DRAG_END:
			if not is_drag_successful():
				if drag_data:
					print("huh")
					drag_data.update_ui()
					drag_data = null
		Node.NOTIFICATION_SCENE_INSTANTIATED:
			print("MechanicPanel NOTIFICATION_SCENE_INSTANTIATED")
		Node.NOTIFICATION_POST_ENTER_TREE:
			print("MechanicPanel NOTIFICATION_POST_ENTER_TREE")

func _can_drop_data(_at_position: Vector2, _data: Variant) -> bool:
	return false

func _on_entity_remove(id: int) -> void:
	_id2button[id].queue_free()
	_id2button.erase(id)

	_id2inspector[id].eject_all()
	_id2inspector[id].queue_free()
	_id2inspector.erase(id)

func _on_entity_update(id: int) -> void:
	var btn: EntityButton = _id2button.get(id)
	var ins: EntityInspector = _id2inspector.get(id)
	if btn:
		btn.text = MechanicManager.entity_trees[id].e_name
		btn.name = MechanicManager.entity_trees[id].e_name
	else:
		_init_entity_button(id)
	if ins:
		ins.name = MechanicManager.entity_trees[id].e_name
		

func _on_player_dead() -> void:
	death_msg.show()
