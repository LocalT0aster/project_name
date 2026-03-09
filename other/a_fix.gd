@tool
extends Node

@export var fix : bool = false:
	set(_value):
		resolve()

@export var root_node : Node
@export var animation_p : AnimationPlayer

func resolve():
	for a_name in animation_p.get_animation_list():
		var animation : Animation = animation_p.get_animation(a_name)
		for i in animation.get_track_count() - 1:
			resolve_track(animation, i)

func resolve_track(animation : Animation, i : int):
	var path:NodePath = animation.track_get_path(i)
	var node_name = path.get_name(path.get_name_count() - 1)
	var subname = path.slice(path.get_name_count())
	var new_path
	if node_name == ".":
		new_path = root_node.get_path_to(root_node)
	else:
		new_path = root_node.get_path_to(root_node.find_child(node_name))
	var f_path = NodePath(str(new_path) + str(subname))
	animation.track_set_path(i, f_path)
