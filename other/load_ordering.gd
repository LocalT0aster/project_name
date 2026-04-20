class_name LoadOrdering
extends Node
#
#var loaded: Dictionary[StringName, Node] = {}
#
#const SCRIPT_ID: StringName = &"LoadOrdering"
#
#func _ready() -> void:
	#get_node(^"/root/Level").ready.connect(init)
	#print(SCRIPT_ID + " ready")
#
#func init() -> void:
	#if not loaded.get(MechanicManager.SCRIPT_ID):
		#MechanicManager._ready()
		#MechanicManager.ready.emit()
	#loaded[MechanicManager.SCRIPT_ID].init()
	#
	#for e in MechanicManager.entity_trees.values():
		#e.init()
	#
	#if loaded.get(MechanicPanel.SCRIPT_ID):
		#loaded[MechanicPanel.SCRIPT_ID].init()
	#else:
		#printerr("Where MechanicPanel?")
	#
	#print(SCRIPT_ID + " init")
	#loaded[SCRIPT_ID] = self
#
#
#func _on_button_pressed() -> void:
	#var obj = load("res://objects/player/player.tscn")
	#var inst: Node2D = obj.instantiate()
	#get_parent().add_child(inst)
	##loaded[MechanicManager.SCRIPT_ID].init()
	##inst.get_node(^"./MechanicsTree").init()
	##if loaded.get(MechanicPanel.SCRIPT_ID):
		##loaded[MechanicPanel.SCRIPT_ID].init()
