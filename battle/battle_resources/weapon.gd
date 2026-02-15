extends Node

class_name Weapon

var stats = {
		"head": 0,
		"torso": 0,
		"left_hand": 0,
		"right_hand": 0,
		"left_leg":0,
		"right_leg":0
	}

func _init(head : int, torso : int, lhand : int, rhand : int, lleg : int, rleg : int) -> void:
	stats = {
		"head": 0,
		"torso": 0,
		"left_hand": 0,
		"right_hand": 0,
		"left_leg": 0,
		"right_leg": 0
	}
